package ch.ethz.systems.netbench.xpt.ports.APPIFO;

import ch.ethz.systems.netbench.core.log.SimulationLogger;
import ch.ethz.systems.netbench.core.network.NetworkDevice;
import ch.ethz.systems.netbench.core.network.Packet;
import ch.ethz.systems.netbench.xpt.tcpbase.FullExtTcpPacket;
import ch.ethz.systems.netbench.xpt.tcpbase.PriorityHeader;

import java.util.*;
import java.util.concurrent.ArrayBlockingQueue;

public class APPIFOQueue1 implements Queue<Packet> {

    private class TreeNode {
        float lower;
        float upper;
        TreeNode left;
        TreeNode right;
        int queueIndex;

        TreeNode(float bound, int queueIndex) {
            this.lower = bound;
            this.upper = bound;
            this.left = null;
            this.right = null;
            this.queueIndex = queueIndex;
        }
    }

    private TreeNode root;
    private final long perQueueCapacity;
    private int ownId;
    private int totalQueues;
    private List<ArrayBlockingQueue<Packet>> queueList;
    private List<Float> queueBounds;

    public APPIFOQueue1(long numQueues, long perQueueCapacity, NetworkDevice ownNetworkDevice, String stepSize) {
        this.perQueueCapacity = perQueueCapacity;
        this.ownId = ownNetworkDevice.getIdentifier();
        this.totalQueues = (int)numQueues;
        this.queueList = new ArrayList<>();
        this.queueBounds = new ArrayList<>();
        
        for (int i = 0; i < totalQueues; i++) {
            queueList.add(new ArrayBlockingQueue<>((int)perQueueCapacity));
            queueBounds.add(0f);
        }
        
        this.root = buildTree(0, totalQueues - 1);
    }

    private TreeNode buildTree(int start, int end) {
        if (start > end) return null;
        
        int mid = (start + end) / 2;
        TreeNode node = new TreeNode(0, mid);
        
        if (start == end) {
            return node;
        }
        
        node.left = buildTree(start, mid);
        node.right = buildTree(mid + 1, end);
        
        node.lower = (node.left.lower + node.left.upper) / 2;
        node.upper = (node.right.lower + node.right.upper) / 2;
        
        return node;
    }

    @Override
    public boolean offer(Packet packet) {
        PriorityHeader header = (PriorityHeader) packet;
        float rank = header.getPriority();

        return offerToNode(root, packet, rank, 0, totalQueues - 1);
    }

    private boolean offerToNode(TreeNode node, Packet packet, float rank, int start, int end) {
        if (node == null) return false;

        if (start == end) {
            ArrayBlockingQueue<Packet> queue = queueList.get(node.queueIndex);
            if (queue.size() == perQueueCapacity) {
                return false;
            }

            boolean result = queue.offer(packet);
            if (result) {
                node.lower = node.upper = rank;
                queueBounds.set(node.queueIndex, rank);
                updateBounds(root, start, 0, totalQueues - 1);
            }
            return result;
        }

        int mid = (start + end) / 2;
        float avg = (node.lower + node.upper) / 2;
        if (rank <= avg) {
            boolean result = offerToNode(node.left, packet, rank, start, mid);
            if (result) {
                node.lower = (node.left.lower + node.left.upper) / 2;
            }
            return result;
        } else {
            boolean result = offerToNode(node.right, packet, rank, mid + 1, end);
            if (result) {
                node.upper = (node.right.lower + node.right.upper) / 2;
            }
            return result;
        }
    }

    private void updateBounds(TreeNode node, int updatedQueue, int start, int end) {
        if (node == null) return;

        if (start == end) return;

        int mid = (start + end) / 2;
        if (updatedQueue <= mid) {
            updateBounds(node.left, updatedQueue, start, mid);
            node.lower = (node.left.lower + node.left.upper) / 2;
        } else {
            updateBounds(node.right, updatedQueue, mid + 1, end);
            node.upper = (node.right.lower + node.right.upper) / 2;
        }
    }

    @Override
    public Packet poll() {
        for (int q = 0; q < queueList.size(); q++) {
            Packet p = queueList.get(q).poll();
            if (p != null) {
                PriorityHeader header = (PriorityHeader) p;
                int rank = (int)header.getPriority();

                if(SimulationLogger.hasRankMappingEnabled()){
                    SimulationLogger.logRankMapping(this.ownId, rank, q);
                }

                if(SimulationLogger.hasQueueBoundTrackingEnabled()){
                    for (int c = queueList.size() - 1; c >= 0; c--) {
                        SimulationLogger.logQueueBound(this.ownId, c, queueBounds.get(c).intValue());
                    }
                }

                if (SimulationLogger.hasInversionsTrackingEnabled()) {
                    int count_inversions = 0;
                    for (int i = 0; i < queueList.size(); i++) {
                        Object[] currentQueue = queueList.get(i).toArray();
                        for (int j = 0; j < currentQueue.length; j++) {
                            int r = (int) ((FullExtTcpPacket) currentQueue[j]).getPriority();
                            if (r < rank) {
                                count_inversions++;
                            }
                        }
                    }
                    if (count_inversions != 0) {
                        SimulationLogger.logInversionsPerRank(this.ownId, rank, count_inversions);
                    }
                }
                return p;
            }
        }
        return null;
    }

    @Override
    public Packet peek() {
        for (ArrayBlockingQueue<Packet> queue : queueList) {
            Packet p = queue.peek();
            if (p != null) {
                return p;
            }
        }
        return null;
    }

    @Override
    public boolean add(Packet packet) {
        if (offer(packet)) {
            return true;
        }
        throw new IllegalStateException("Queue is full");
    }

    @Override
    public Packet remove() {
        Packet p = poll();
        if (p == null) {
            throw new NoSuchElementException();
        }
        return p;
    }

    @Override
    public Packet element() {
        Packet p = peek();
        if (p == null) {
            throw new NoSuchElementException();
        }
        return p;
    }

    @Override
    public void clear() {
        for (ArrayBlockingQueue<Packet> queue : queueList) {
            queue.clear();
        }
        for (int i = 0; i < queueBounds.size(); i++) {
            queueBounds.set(i, 0f);
        }
    }

    @Override
    public int size() {
        int totalSize = 0;
        for (ArrayBlockingQueue<Packet> queue : queueList) {
            totalSize += queue.size();
        }
        return totalSize;
    }

    @Override
    public boolean isEmpty() {
        for (ArrayBlockingQueue<Packet> queue : queueList) {
            if (!queue.isEmpty()) {
                return false;
            }
        }
        return true;
    }

    @Override
    public boolean contains(Object o) {
        for (ArrayBlockingQueue<Packet> queue : queueList) {
            if (queue.contains(o)) {
                return true;
            }
        }
        return false;
    }

    @Override
    public Iterator<Packet> iterator() {
        return new Iterator<Packet>() {
            private int currentQueueIndex = 0;
            private Iterator<Packet> currentQueueIterator = queueList.get(0).iterator();

            @Override
            public boolean hasNext() {
                while (!currentQueueIterator.hasNext() && currentQueueIndex < queueList.size() - 1) {
                    currentQueueIndex++;
                    currentQueueIterator = queueList.get(currentQueueIndex).iterator();
                }
                return currentQueueIterator.hasNext();
            }

            @Override
            public Packet next() {
                if (!hasNext()) {
                    throw new NoSuchElementException();
                }
                return currentQueueIterator.next();
            }

            @Override
            public void remove() {
                throw new UnsupportedOperationException("Remove operation is not supported");
            }
        };
    }

    @Override
    public Object[] toArray() {
        List<Packet> allPackets = new ArrayList<>();
        for (ArrayBlockingQueue<Packet> queue : queueList) {
            allPackets.addAll(queue);
        }
        return allPackets.toArray();
    }

    @Override
    public <T> T[] toArray(T[] a) {
        List<Packet> allPackets = new ArrayList<>();
        for (ArrayBlockingQueue<Packet> queue : queueList) {
            allPackets.addAll(queue);
        }
        return allPackets.toArray(a);
    }

    @Override
    public boolean remove(Object o) {
        for (ArrayBlockingQueue<Packet> queue : queueList) {
            if (queue.remove(o)) {
                return true;
            }
        }
        return false;
    }

    @Override
    public boolean containsAll(Collection<?> c) {
        for (Object o : c) {
            if (!contains(o)) {
                return false;
            }
        }
        return true;
    }

    @Override
    public boolean addAll(Collection<? extends Packet> c) {
        boolean modified = false;
        for (Packet packet : c) {
            if (offer(packet)) {
                modified = true;
            }
        }
        return modified;
    }

    @Override
    public boolean removeAll(Collection<?> c) {
        boolean modified = false;
        for (Object o : c) {
            modified |= remove(o);
        }
        return modified;
    }

    @Override
    public boolean retainAll(Collection<?> c) {
        boolean modified = false;
        Iterator<Packet> iterator = iterator();
        while (iterator.hasNext()) {
            if (!c.contains(iterator.next())) {
                iterator.remove();
                modified = true;
            }
        }
        return modified;
    }
}