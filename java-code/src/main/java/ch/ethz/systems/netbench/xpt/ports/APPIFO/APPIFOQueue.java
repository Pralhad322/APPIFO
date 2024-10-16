package ch.ethz.systems.netbench.xpt.ports.APPIFO;

import ch.ethz.systems.netbench.core.log.SimulationLogger;
import ch.ethz.systems.netbench.core.network.NetworkDevice;
import ch.ethz.systems.netbench.core.network.Packet;
import ch.ethz.systems.netbench.xpt.tcpbase.FullExtTcpPacket;
import ch.ethz.systems.netbench.xpt.tcpbase.PriorityHeader;

import java.util.*;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.locks.ReentrantLock;

public class APPIFOQueue implements Queue {

    private final ArrayList<ArrayBlockingQueue<Packet>> queueList;
    private final BitSet fullQueues;
    private final int[] packetCounts;
    private final int numQueues;
    private final int perQueueCapacity;
    private int highestPriorityQueueIndex;
    private int ownId;
    private ReentrantLock reentrantLock;

    public APPIFOQueue(long numQueues, long perQueueCapacity, NetworkDevice ownNetworkDevice){
        this.numQueues = (int) numQueues;
        this.perQueueCapacity = (int) perQueueCapacity;
        this.queueList = new ArrayList<>(this.numQueues);
        this.fullQueues = new BitSet(this.numQueues);
        this.packetCounts = new int[this.numQueues];
        this.highestPriorityQueueIndex = 0;
        this.ownId = ownNetworkDevice.getIdentifier();
        this.reentrantLock = new ReentrantLock();

        for (int i = 0; i < this.numQueues; i++) {
            queueList.add(new ArrayBlockingQueue<>(this.perQueueCapacity));
        }
    }

    // Packet dropped and null returned if selected queue exceeds its size
    @Override
    public boolean offer(Object o) {

        reentrantLock.lock();
        try {
            // Extract rank from header
            Packet packet = (Packet) o;
            PriorityHeader header = (PriorityHeader) packet;
            int rank = (int) header.getPriority();

            int targetQueue = (highestPriorityQueueIndex + rank) % numQueues;

            for (int i = 0; i < numQueues; i++) {
                int queueIndex = (targetQueue + i) % numQueues;
                if (!fullQueues.get(queueIndex)) {
                    boolean added = queueList.get(queueIndex).offer(packet);
                    if (added) {
                        packetCounts[queueIndex]++;
                        if (packetCounts[queueIndex] == perQueueCapacity) {
                            fullQueues.set(queueIndex);
                        }

                        // Log rank of packet enqueued and queue selected if enabled
                        if (SimulationLogger.hasRankMappingEnabled()) {
                            SimulationLogger.logRankMapping(this.ownId, rank, queueIndex);
                        }

                        if (SimulationLogger.hasQueueBoundTrackingEnabled()) {
                            for (int c = numQueues - 1; c >= 0; c--) {
                                SimulationLogger.logQueueBound(this.ownId, c, packetCounts[c]);
                            }
                        }

                        return true;
                    }
                }
            }
            return false; // All queues are full
        } finally {
            reentrantLock.unlock();
        }
    }

    @Override
    public Packet poll() {
        reentrantLock.lock();
        try {
            if (isEmpty()) {
                return null;
            }

            Packet p = queueList.get(highestPriorityQueueIndex).poll();
            if (p != null) {
                packetCounts[highestPriorityQueueIndex]--;
                fullQueues.clear(highestPriorityQueueIndex);

                PriorityHeader header = (PriorityHeader) p;
                int rank = (int) header.getPriority();

                // Log rank of packet dequeued and queue selected if enabled
                if (SimulationLogger.hasRankMappingEnabled()) {
                    SimulationLogger.logRankMapping(this.ownId, rank, highestPriorityQueueIndex);
                }

                if (SimulationLogger.hasQueueBoundTrackingEnabled()) {
                    for (int c = numQueues - 1; c >= 0; c--) {
                        SimulationLogger.logQueueBound(this.ownId, c, packetCounts[c]);
                    }
                }

                // Check whether there is an inversion: a packet with smaller rank in queue than the one polled
                if (SimulationLogger.hasInversionsTrackingEnabled()) {
                    int count_inversions = 0;
                    for (int i = 0; i <= numQueues - 1; i++) {
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

                if (packetCounts[highestPriorityQueueIndex] == 0) {
                    rotateQueuePriorities();
                }

                return p;
            }
            return null;
        } finally {
            reentrantLock.unlock();
        }
    }

    private void rotateQueuePriorities() {
        highestPriorityQueueIndex = (highestPriorityQueueIndex + 1) % numQueues;
    }

    @Override
    public int size() {
        int size = 0;
        for (int q=0; q<queueList.size(); q++){
            size += queueList.get(q).size();
        }
        return size;
    }

    @Override
    public boolean isEmpty() {
        boolean empty = true;
        for (int q=0; q<queueList.size(); q++){
            if(!queueList.get(q).isEmpty()){
                empty = false;
            }
        }
        return empty;
    }

    @Override
    public boolean contains(Object o) {
        return false;
    }

    @Override
    public Iterator iterator() {
        return null;
    }

    @Override
    public Object[] toArray() {
        return new Object[0];
    }

    @Override
    public Object[] toArray(Object[] objects) {
        return new Object[0];
    }

    @Override
    public boolean add(Object o) {
        return false;
    }

    @Override
    public boolean remove(Object o) {
        return false;
    }

    @Override
    public boolean addAll(Collection collection) {
        return false;
    }

    @Override
    public void clear() { }

    @Override
    public boolean retainAll(Collection collection) {
        return false;
    }

    @Override
    public boolean removeAll(Collection collection) {
        return false;
    }

    @Override
    public boolean containsAll(Collection collection) {
        return false;
    }

    @Override
    public Object remove() {
        return null;
    }

    @Override
    public Object element() {
        return null;
    }

    @Override
    public Object peek() {
        return null;
    }
}
