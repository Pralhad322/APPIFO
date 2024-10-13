#!/usr/bin/env bash

calc() { awk "BEGIN{print $*}"; }

############################################################################################################################
############################################################################################################################
############################################################################################################################

# GENERAL SETTINGS
# 97500 (65 packets) or 30000 (20 packets)
ecn_threshold=30000
num_flows=6000000
intermediary=uniform
FLOWLET_GAP_NS=50000
traffic_flow_size_dist=pareto
hybrid_threshold_bytes=100000
k_for_k_shortest_paths=8

# 360 servers (45x8, 72x5)
flows_per_s=500000
actservers=360
a2a_fraction_ft=0.32
a2a_fraction_xp=0.3
runtime=`calc ${num_flows} / ${flows_per_s}`;

ssh user@machine.com "cd /path/to/folder/netbench; screen -d -m ../java/jre1.8.0_131/bin/java -ea -jar NetBench.jar private/runs/3_4_all_to_all_fraction/full_fat_tree_k16.properties run_folder_name=14_pareto_all_to_all/30perc/full_fat_tree_k16_actservers_${actservers}_flows_${flows_per_s}_runtime_${runtime}s_ecn_threshold_${ecn_threshold}_intermediary_${intermediary}_flowlet_gap_${FLOWLET_GAP_NS} output_port_ecn_threshold_k_bytes=${ecn_threshold} traffic_lambda_flow_starts_per_s=${flows_per_s} run_time_s=${runtime} network_device_intermediary=${intermediary} FLOWLET_GAP_NS=${FLOWLET_GAP_NS} traffic_flow_size_dist=${traffic_flow_size_dist} traffic_flow_size_dist_pareto_shape=1.05 traffic_flow_size_dist_pareto_mean_kilobytes=100 traffic_probabilities_active_fraction=${a2a_fraction_ft}"
ssh user@machine.com "cd /path/to/folder/netbench; screen -d -m ../java/jre1.8.0_131/bin/java -ea -jar NetBench.jar private/runs/3_4_all_to_all_fraction/xpander_n216_d11_vlb.properties run_folder_name=14_pareto_all_to_all/30perc/xpander_n216_d11_vlb_actservers_${actservers}_flows_${flows_per_s}_runtime_${runtime}s_ecn_threshold_${ecn_threshold}_intermediary_${intermediary}_flowlet_gap_${FLOWLET_GAP_NS} output_port_ecn_threshold_k_bytes=${ecn_threshold} traffic_lambda_flow_starts_per_s=${flows_per_s} run_time_s=${runtime} network_device_intermediary=${intermediary} FLOWLET_GAP_NS=${FLOWLET_GAP_NS} traffic_flow_size_dist=${traffic_flow_size_dist} traffic_flow_size_dist_pareto_shape=1.05 traffic_flow_size_dist_pareto_mean_kilobytes=100 traffic_probabilities_active_fraction=${a2a_fraction_xp}"
ssh user@machine.com "cd /path/to/folder/netbench; screen -d -m ../java/jre1.8.0_131/bin/java -ea -jar NetBench.jar private/runs/3_4_all_to_all_fraction/xpander_n216_d11_ecmp.properties run_folder_name=14_pareto_all_to_all/30perc/xpander_n216_d11_ecmp_actservers_${actservers}_flows_${flows_per_s}_runtime_${runtime}s_ecn_threshold_${ecn_threshold}_intermediary_${intermediary}_flowlet_gap_${FLOWLET_GAP_NS} output_port_ecn_threshold_k_bytes=${ecn_threshold} traffic_lambda_flow_starts_per_s=${flows_per_s} run_time_s=${runtime} network_device_intermediary=${intermediary} FLOWLET_GAP_NS=${FLOWLET_GAP_NS} traffic_flow_size_dist=${traffic_flow_size_dist} traffic_flow_size_dist_pareto_shape=1.05 traffic_flow_size_dist_pareto_mean_kilobytes=100 traffic_probabilities_active_fraction=${a2a_fraction_xp}"
ssh user@machine.com "cd /path/to/folder/netbench; screen -d -m ../java/jre1.8.0_131/bin/java -ea -jar NetBench.jar private/runs/3_4_all_to_all_fraction/xpander_n216_d11_hybrid.properties run_folder_name=14_pareto_all_to_all/30perc/xpander_n216_d11_hybrid_actservers_${actservers}_flows_${flows_per_s}_runtime_${runtime}s_ecn_threshold_${ecn_threshold}_intermediary_${intermediary}_flowlet_gap_${FLOWLET_GAP_NS} output_port_ecn_threshold_k_bytes=${ecn_threshold} traffic_lambda_flow_starts_per_s=${flows_per_s} run_time_s=${runtime} network_device_intermediary=${intermediary} FLOWLET_GAP_NS=${FLOWLET_GAP_NS} traffic_flow_size_dist=${traffic_flow_size_dist} traffic_flow_size_dist_pareto_shape=1.05 traffic_flow_size_dist_pareto_mean_kilobytes=100 routing_ecmp_then_valiant_switch_threshold_bytes=${hybrid_threshold_bytes} traffic_probabilities_active_fraction=${a2a_fraction_xp}"
ssh user@machine.com "cd /path/to/folder/netbench; screen -d -m ../java/jre1.8.0_131/bin/java -ea -jar NetBench.jar private/runs/3_4_all_to_all_fraction/xpander_n216_d11_ksp.properties run_folder_name=14_pareto_all_to_all/30perc/xpander_n216_d11_ksp_${k_for_k_shortest_paths}_actservers_${actservers}_flows_${flows_per_s}_runtime_${runtime}s_ecn_threshold_${ecn_threshold}_intermediary_${intermediary}_flowlet_gap_${FLOWLET_GAP_NS} output_port_ecn_threshold_k_bytes=${ecn_threshold} traffic_lambda_flow_starts_per_s=${flows_per_s} run_time_s=${runtime} network_device_intermediary=${intermediary} FLOWLET_GAP_NS=${FLOWLET_GAP_NS} traffic_flow_size_dist=${traffic_flow_size_dist} traffic_flow_size_dist_pareto_shape=1.05 traffic_flow_size_dist_pareto_mean_kilobytes=100 traffic_probabilities_active_fraction=${a2a_fraction_xp} k_for_k_shortest_paths=${k_for_k_shortest_paths}"
ssh user@machine.com "cd /path/to/folder/netbench; screen -d -m ../java/jre1.8.0_131/bin/java -ea -jar NetBench.jar private/runs/3_4_all_to_all_fraction/xpander_n216_d11_hybrid_ksp.properties run_folder_name=14_pareto_all_to_all/30perc/xpander_n216_d11_hybrid_ksp_${k_for_k_shortest_paths}_actservers_${actservers}_flows_${flows_per_s}_runtime_${runtime}s_ecn_threshold_${ecn_threshold}_intermediary_${intermediary}_flowlet_gap_${FLOWLET_GAP_NS} output_port_ecn_threshold_k_bytes=${ecn_threshold} traffic_lambda_flow_starts_per_s=${flows_per_s} run_time_s=${runtime} network_device_intermediary=${intermediary} FLOWLET_GAP_NS=${FLOWLET_GAP_NS} traffic_flow_size_dist=${traffic_flow_size_dist} traffic_flow_size_dist_pareto_shape=1.05 traffic_flow_size_dist_pareto_mean_kilobytes=100 traffic_probabilities_active_fraction=${a2a_fraction_xp} k_for_k_shortest_paths=${k_for_k_shortest_paths} routing_ecmp_then_source_routing_switch_threshold_bytes=${hybrid_threshold_bytes}"

echo "Increasing pairings fraction deployment (${flows_per_s}) finished."

# 360 servers (45x8, 72x5)
flows_per_s=1000000
actservers=360
a2a_fraction_ft=0.32
a2a_fraction_xp=0.3
runtime=`calc ${num_flows} / ${flows_per_s}`;

ssh user@machine.com "cd /path/to/folder/netbench; screen -d -m ../java/jre1.8.0_131/bin/java -ea -jar NetBench.jar private/runs/3_4_all_to_all_fraction/full_fat_tree_k16.properties run_folder_name=14_pareto_all_to_all/30perc/full_fat_tree_k16_actservers_${actservers}_flows_${flows_per_s}_runtime_${runtime}s_ecn_threshold_${ecn_threshold}_intermediary_${intermediary}_flowlet_gap_${FLOWLET_GAP_NS} output_port_ecn_threshold_k_bytes=${ecn_threshold} traffic_lambda_flow_starts_per_s=${flows_per_s} run_time_s=${runtime} network_device_intermediary=${intermediary} FLOWLET_GAP_NS=${FLOWLET_GAP_NS} traffic_flow_size_dist=${traffic_flow_size_dist} traffic_flow_size_dist_pareto_shape=1.05 traffic_flow_size_dist_pareto_mean_kilobytes=100 traffic_probabilities_active_fraction=${a2a_fraction_ft}"
ssh user@machine.com "cd /path/to/folder/netbench; screen -d -m ../java/jre1.8.0_131/bin/java -ea -jar NetBench.jar private/runs/3_4_all_to_all_fraction/xpander_n216_d11_vlb.properties run_folder_name=14_pareto_all_to_all/30perc/xpander_n216_d11_vlb_actservers_${actservers}_flows_${flows_per_s}_runtime_${runtime}s_ecn_threshold_${ecn_threshold}_intermediary_${intermediary}_flowlet_gap_${FLOWLET_GAP_NS} output_port_ecn_threshold_k_bytes=${ecn_threshold} traffic_lambda_flow_starts_per_s=${flows_per_s} run_time_s=${runtime} network_device_intermediary=${intermediary} FLOWLET_GAP_NS=${FLOWLET_GAP_NS} traffic_flow_size_dist=${traffic_flow_size_dist} traffic_flow_size_dist_pareto_shape=1.05 traffic_flow_size_dist_pareto_mean_kilobytes=100 traffic_probabilities_active_fraction=${a2a_fraction_xp}"
ssh user@machine.com "cd /path/to/folder/netbench; screen -d -m ../java/jre1.8.0_131/bin/java -ea -jar NetBench.jar private/runs/3_4_all_to_all_fraction/xpander_n216_d11_ecmp.properties run_folder_name=14_pareto_all_to_all/30perc/xpander_n216_d11_ecmp_actservers_${actservers}_flows_${flows_per_s}_runtime_${runtime}s_ecn_threshold_${ecn_threshold}_intermediary_${intermediary}_flowlet_gap_${FLOWLET_GAP_NS} output_port_ecn_threshold_k_bytes=${ecn_threshold} traffic_lambda_flow_starts_per_s=${flows_per_s} run_time_s=${runtime} network_device_intermediary=${intermediary} FLOWLET_GAP_NS=${FLOWLET_GAP_NS} traffic_flow_size_dist=${traffic_flow_size_dist} traffic_flow_size_dist_pareto_shape=1.05 traffic_flow_size_dist_pareto_mean_kilobytes=100 traffic_probabilities_active_fraction=${a2a_fraction_xp}"
ssh user@machine.com "cd /path/to/folder/netbench; screen -d -m ../java/jre1.8.0_131/bin/java -ea -jar NetBench.jar private/runs/3_4_all_to_all_fraction/xpander_n216_d11_hybrid.properties run_folder_name=14_pareto_all_to_all/30perc/xpander_n216_d11_hybrid_actservers_${actservers}_flows_${flows_per_s}_runtime_${runtime}s_ecn_threshold_${ecn_threshold}_intermediary_${intermediary}_flowlet_gap_${FLOWLET_GAP_NS} output_port_ecn_threshold_k_bytes=${ecn_threshold} traffic_lambda_flow_starts_per_s=${flows_per_s} run_time_s=${runtime} network_device_intermediary=${intermediary} FLOWLET_GAP_NS=${FLOWLET_GAP_NS} traffic_flow_size_dist=${traffic_flow_size_dist} traffic_flow_size_dist_pareto_shape=1.05 traffic_flow_size_dist_pareto_mean_kilobytes=100 routing_ecmp_then_valiant_switch_threshold_bytes=${hybrid_threshold_bytes} traffic_probabilities_active_fraction=${a2a_fraction_xp}"
ssh user@machine.com "cd /path/to/folder/netbench; screen -d -m ../java/jre1.8.0_131/bin/java -ea -jar NetBench.jar private/runs/3_4_all_to_all_fraction/xpander_n216_d11_ksp.properties run_folder_name=14_pareto_all_to_all/30perc/xpander_n216_d11_ksp_${k_for_k_shortest_paths}_actservers_${actservers}_flows_${flows_per_s}_runtime_${runtime}s_ecn_threshold_${ecn_threshold}_intermediary_${intermediary}_flowlet_gap_${FLOWLET_GAP_NS} output_port_ecn_threshold_k_bytes=${ecn_threshold} traffic_lambda_flow_starts_per_s=${flows_per_s} run_time_s=${runtime} network_device_intermediary=${intermediary} FLOWLET_GAP_NS=${FLOWLET_GAP_NS} traffic_flow_size_dist=${traffic_flow_size_dist} traffic_flow_size_dist_pareto_shape=1.05 traffic_flow_size_dist_pareto_mean_kilobytes=100 traffic_probabilities_active_fraction=${a2a_fraction_xp} k_for_k_shortest_paths=${k_for_k_shortest_paths}"
ssh user@machine.com "cd /path/to/folder/netbench; screen -d -m ../java/jre1.8.0_131/bin/java -ea -jar NetBench.jar private/runs/3_4_all_to_all_fraction/xpander_n216_d11_hybrid_ksp.properties run_folder_name=14_pareto_all_to_all/30perc/xpander_n216_d11_hybrid_ksp_${k_for_k_shortest_paths}_actservers_${actservers}_flows_${flows_per_s}_runtime_${runtime}s_ecn_threshold_${ecn_threshold}_intermediary_${intermediary}_flowlet_gap_${FLOWLET_GAP_NS} output_port_ecn_threshold_k_bytes=${ecn_threshold} traffic_lambda_flow_starts_per_s=${flows_per_s} run_time_s=${runtime} network_device_intermediary=${intermediary} FLOWLET_GAP_NS=${FLOWLET_GAP_NS} traffic_flow_size_dist=${traffic_flow_size_dist} traffic_flow_size_dist_pareto_shape=1.05 traffic_flow_size_dist_pareto_mean_kilobytes=100 traffic_probabilities_active_fraction=${a2a_fraction_xp} k_for_k_shortest_paths=${k_for_k_shortest_paths} routing_ecmp_then_source_routing_switch_threshold_bytes=${hybrid_threshold_bytes}"

echo "Increasing pairings fraction deployment (${flows_per_s}) finished."

# 360 servers (45x8, 72x5)
flows_per_s=2000000
actservers=360
a2a_fraction_ft=0.32
a2a_fraction_xp=0.3
runtime=`calc ${num_flows} / ${flows_per_s}`;

ssh user@machine.com "cd /path/to/folder/netbench; screen -d -m ../java/jre1.8.0_131/bin/java -ea -jar NetBench.jar private/runs/3_4_all_to_all_fraction/full_fat_tree_k16.properties run_folder_name=14_pareto_all_to_all/30perc/full_fat_tree_k16_actservers_${actservers}_flows_${flows_per_s}_runtime_${runtime}s_ecn_threshold_${ecn_threshold}_intermediary_${intermediary}_flowlet_gap_${FLOWLET_GAP_NS} output_port_ecn_threshold_k_bytes=${ecn_threshold} traffic_lambda_flow_starts_per_s=${flows_per_s} run_time_s=${runtime} network_device_intermediary=${intermediary} FLOWLET_GAP_NS=${FLOWLET_GAP_NS} traffic_flow_size_dist=${traffic_flow_size_dist} traffic_flow_size_dist_pareto_shape=1.05 traffic_flow_size_dist_pareto_mean_kilobytes=100 traffic_probabilities_active_fraction=${a2a_fraction_ft}"
ssh user@machine.com "cd /path/to/folder/netbench; screen -d -m ../java/jre1.8.0_131/bin/java -ea -jar NetBench.jar private/runs/3_4_all_to_all_fraction/xpander_n216_d11_vlb.properties run_folder_name=14_pareto_all_to_all/30perc/xpander_n216_d11_vlb_actservers_${actservers}_flows_${flows_per_s}_runtime_${runtime}s_ecn_threshold_${ecn_threshold}_intermediary_${intermediary}_flowlet_gap_${FLOWLET_GAP_NS} output_port_ecn_threshold_k_bytes=${ecn_threshold} traffic_lambda_flow_starts_per_s=${flows_per_s} run_time_s=${runtime} network_device_intermediary=${intermediary} FLOWLET_GAP_NS=${FLOWLET_GAP_NS} traffic_flow_size_dist=${traffic_flow_size_dist} traffic_flow_size_dist_pareto_shape=1.05 traffic_flow_size_dist_pareto_mean_kilobytes=100 traffic_probabilities_active_fraction=${a2a_fraction_xp}"
ssh user@machine.com "cd /path/to/folder/netbench; screen -d -m ../java/jre1.8.0_131/bin/java -ea -jar NetBench.jar private/runs/3_4_all_to_all_fraction/xpander_n216_d11_ecmp.properties run_folder_name=14_pareto_all_to_all/30perc/xpander_n216_d11_ecmp_actservers_${actservers}_flows_${flows_per_s}_runtime_${runtime}s_ecn_threshold_${ecn_threshold}_intermediary_${intermediary}_flowlet_gap_${FLOWLET_GAP_NS} output_port_ecn_threshold_k_bytes=${ecn_threshold} traffic_lambda_flow_starts_per_s=${flows_per_s} run_time_s=${runtime} network_device_intermediary=${intermediary} FLOWLET_GAP_NS=${FLOWLET_GAP_NS} traffic_flow_size_dist=${traffic_flow_size_dist} traffic_flow_size_dist_pareto_shape=1.05 traffic_flow_size_dist_pareto_mean_kilobytes=100 traffic_probabilities_active_fraction=${a2a_fraction_xp}"
ssh user@machine.com "cd /path/to/folder/netbench; screen -d -m ../java/jre1.8.0_131/bin/java -ea -jar NetBench.jar private/runs/3_4_all_to_all_fraction/xpander_n216_d11_hybrid.properties run_folder_name=14_pareto_all_to_all/30perc/xpander_n216_d11_hybrid_actservers_${actservers}_flows_${flows_per_s}_runtime_${runtime}s_ecn_threshold_${ecn_threshold}_intermediary_${intermediary}_flowlet_gap_${FLOWLET_GAP_NS} output_port_ecn_threshold_k_bytes=${ecn_threshold} traffic_lambda_flow_starts_per_s=${flows_per_s} run_time_s=${runtime} network_device_intermediary=${intermediary} FLOWLET_GAP_NS=${FLOWLET_GAP_NS} traffic_flow_size_dist=${traffic_flow_size_dist} traffic_flow_size_dist_pareto_shape=1.05 traffic_flow_size_dist_pareto_mean_kilobytes=100 routing_ecmp_then_valiant_switch_threshold_bytes=${hybrid_threshold_bytes} traffic_probabilities_active_fraction=${a2a_fraction_xp}"
ssh user@machine.com "cd /path/to/folder/netbench; screen -d -m ../java/jre1.8.0_131/bin/java -ea -jar NetBench.jar private/runs/3_4_all_to_all_fraction/xpander_n216_d11_ksp.properties run_folder_name=14_pareto_all_to_all/30perc/xpander_n216_d11_ksp_${k_for_k_shortest_paths}_actservers_${actservers}_flows_${flows_per_s}_runtime_${runtime}s_ecn_threshold_${ecn_threshold}_intermediary_${intermediary}_flowlet_gap_${FLOWLET_GAP_NS} output_port_ecn_threshold_k_bytes=${ecn_threshold} traffic_lambda_flow_starts_per_s=${flows_per_s} run_time_s=${runtime} network_device_intermediary=${intermediary} FLOWLET_GAP_NS=${FLOWLET_GAP_NS} traffic_flow_size_dist=${traffic_flow_size_dist} traffic_flow_size_dist_pareto_shape=1.05 traffic_flow_size_dist_pareto_mean_kilobytes=100 traffic_probabilities_active_fraction=${a2a_fraction_xp} k_for_k_shortest_paths=${k_for_k_shortest_paths}"
ssh user@machine.com "cd /path/to/folder/netbench; screen -d -m ../java/jre1.8.0_131/bin/java -ea -jar NetBench.jar private/runs/3_4_all_to_all_fraction/xpander_n216_d11_hybrid_ksp.properties run_folder_name=14_pareto_all_to_all/30perc/xpander_n216_d11_hybrid_ksp_${k_for_k_shortest_paths}_actservers_${actservers}_flows_${flows_per_s}_runtime_${runtime}s_ecn_threshold_${ecn_threshold}_intermediary_${intermediary}_flowlet_gap_${FLOWLET_GAP_NS} output_port_ecn_threshold_k_bytes=${ecn_threshold} traffic_lambda_flow_starts_per_s=${flows_per_s} run_time_s=${runtime} network_device_intermediary=${intermediary} FLOWLET_GAP_NS=${FLOWLET_GAP_NS} traffic_flow_size_dist=${traffic_flow_size_dist} traffic_flow_size_dist_pareto_shape=1.05 traffic_flow_size_dist_pareto_mean_kilobytes=100 traffic_probabilities_active_fraction=${a2a_fraction_xp} k_for_k_shortest_paths=${k_for_k_shortest_paths} routing_ecmp_then_source_routing_switch_threshold_bytes=${hybrid_threshold_bytes}"

echo "Increasing pairings fraction deployment (${flows_per_s}) finished."

# 360 servers (45x8, 72x5)
flows_per_s=3000000
actservers=360
a2a_fraction_ft=0.32
a2a_fraction_xp=0.3
runtime=`calc ${num_flows} / ${flows_per_s}`;

ssh user@machine.com "cd /path/to/folder/netbench; screen -d -m ../java/jre1.8.0_131/bin/java -ea -jar NetBench.jar private/runs/3_4_all_to_all_fraction/full_fat_tree_k16.properties run_folder_name=14_pareto_all_to_all/30perc/full_fat_tree_k16_actservers_${actservers}_flows_${flows_per_s}_runtime_${runtime}s_ecn_threshold_${ecn_threshold}_intermediary_${intermediary}_flowlet_gap_${FLOWLET_GAP_NS} output_port_ecn_threshold_k_bytes=${ecn_threshold} traffic_lambda_flow_starts_per_s=${flows_per_s} run_time_s=${runtime} network_device_intermediary=${intermediary} FLOWLET_GAP_NS=${FLOWLET_GAP_NS} traffic_flow_size_dist=${traffic_flow_size_dist} traffic_flow_size_dist_pareto_shape=1.05 traffic_flow_size_dist_pareto_mean_kilobytes=100 traffic_probabilities_active_fraction=${a2a_fraction_ft}"
ssh user@machine.com "cd /path/to/folder/netbench; screen -d -m ../java/jre1.8.0_131/bin/java -ea -jar NetBench.jar private/runs/3_4_all_to_all_fraction/xpander_n216_d11_vlb.properties run_folder_name=14_pareto_all_to_all/30perc/xpander_n216_d11_vlb_actservers_${actservers}_flows_${flows_per_s}_runtime_${runtime}s_ecn_threshold_${ecn_threshold}_intermediary_${intermediary}_flowlet_gap_${FLOWLET_GAP_NS} output_port_ecn_threshold_k_bytes=${ecn_threshold} traffic_lambda_flow_starts_per_s=${flows_per_s} run_time_s=${runtime} network_device_intermediary=${intermediary} FLOWLET_GAP_NS=${FLOWLET_GAP_NS} traffic_flow_size_dist=${traffic_flow_size_dist} traffic_flow_size_dist_pareto_shape=1.05 traffic_flow_size_dist_pareto_mean_kilobytes=100 traffic_probabilities_active_fraction=${a2a_fraction_xp}"
ssh user@machine.com "cd /path/to/folder/netbench; screen -d -m ../java/jre1.8.0_131/bin/java -ea -jar NetBench.jar private/runs/3_4_all_to_all_fraction/xpander_n216_d11_ecmp.properties run_folder_name=14_pareto_all_to_all/30perc/xpander_n216_d11_ecmp_actservers_${actservers}_flows_${flows_per_s}_runtime_${runtime}s_ecn_threshold_${ecn_threshold}_intermediary_${intermediary}_flowlet_gap_${FLOWLET_GAP_NS} output_port_ecn_threshold_k_bytes=${ecn_threshold} traffic_lambda_flow_starts_per_s=${flows_per_s} run_time_s=${runtime} network_device_intermediary=${intermediary} FLOWLET_GAP_NS=${FLOWLET_GAP_NS} traffic_flow_size_dist=${traffic_flow_size_dist} traffic_flow_size_dist_pareto_shape=1.05 traffic_flow_size_dist_pareto_mean_kilobytes=100 traffic_probabilities_active_fraction=${a2a_fraction_xp}"
ssh user@machine.com "cd /path/to/folder/netbench; screen -d -m ../java/jre1.8.0_131/bin/java -ea -jar NetBench.jar private/runs/3_4_all_to_all_fraction/xpander_n216_d11_hybrid.properties run_folder_name=14_pareto_all_to_all/30perc/xpander_n216_d11_hybrid_actservers_${actservers}_flows_${flows_per_s}_runtime_${runtime}s_ecn_threshold_${ecn_threshold}_intermediary_${intermediary}_flowlet_gap_${FLOWLET_GAP_NS} output_port_ecn_threshold_k_bytes=${ecn_threshold} traffic_lambda_flow_starts_per_s=${flows_per_s} run_time_s=${runtime} network_device_intermediary=${intermediary} FLOWLET_GAP_NS=${FLOWLET_GAP_NS} traffic_flow_size_dist=${traffic_flow_size_dist} traffic_flow_size_dist_pareto_shape=1.05 traffic_flow_size_dist_pareto_mean_kilobytes=100 routing_ecmp_then_valiant_switch_threshold_bytes=${hybrid_threshold_bytes} traffic_probabilities_active_fraction=${a2a_fraction_xp}"
ssh user@machine.com "cd /path/to/folder/netbench; screen -d -m ../java/jre1.8.0_131/bin/java -ea -jar NetBench.jar private/runs/3_4_all_to_all_fraction/xpander_n216_d11_ksp.properties run_folder_name=14_pareto_all_to_all/30perc/xpander_n216_d11_ksp_${k_for_k_shortest_paths}_actservers_${actservers}_flows_${flows_per_s}_runtime_${runtime}s_ecn_threshold_${ecn_threshold}_intermediary_${intermediary}_flowlet_gap_${FLOWLET_GAP_NS} output_port_ecn_threshold_k_bytes=${ecn_threshold} traffic_lambda_flow_starts_per_s=${flows_per_s} run_time_s=${runtime} network_device_intermediary=${intermediary} FLOWLET_GAP_NS=${FLOWLET_GAP_NS} traffic_flow_size_dist=${traffic_flow_size_dist} traffic_flow_size_dist_pareto_shape=1.05 traffic_flow_size_dist_pareto_mean_kilobytes=100 traffic_probabilities_active_fraction=${a2a_fraction_xp} k_for_k_shortest_paths=${k_for_k_shortest_paths}"
ssh user@machine.com "cd /path/to/folder/netbench; screen -d -m ../java/jre1.8.0_131/bin/java -ea -jar NetBench.jar private/runs/3_4_all_to_all_fraction/xpander_n216_d11_hybrid_ksp.properties run_folder_name=14_pareto_all_to_all/30perc/xpander_n216_d11_hybrid_ksp_${k_for_k_shortest_paths}_actservers_${actservers}_flows_${flows_per_s}_runtime_${runtime}s_ecn_threshold_${ecn_threshold}_intermediary_${intermediary}_flowlet_gap_${FLOWLET_GAP_NS} output_port_ecn_threshold_k_bytes=${ecn_threshold} traffic_lambda_flow_starts_per_s=${flows_per_s} run_time_s=${runtime} network_device_intermediary=${intermediary} FLOWLET_GAP_NS=${FLOWLET_GAP_NS} traffic_flow_size_dist=${traffic_flow_size_dist} traffic_flow_size_dist_pareto_shape=1.05 traffic_flow_size_dist_pareto_mean_kilobytes=100 traffic_probabilities_active_fraction=${a2a_fraction_xp} k_for_k_shortest_paths=${k_for_k_shortest_paths} routing_ecmp_then_source_routing_switch_threshold_bytes=${hybrid_threshold_bytes}"

echo "Increasing pairings fraction deployment (${flows_per_s}) finished."

############################################################################################################################
############################################################################################################################
############################################################################################################################
