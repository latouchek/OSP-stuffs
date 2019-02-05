#!/usr/bin/env bash

IF_LIST="enp3s0f0 enp3s0f1 enp4s0f0 enp4s0f1 ens2f0 ens2f1"
for IFACE in $IF_LIST; do
  TOE_OPTIONS="rx tx sg tso ufo gso gro lro rxvlan txvlan rxhash"
  for TOE_OPTION in $TOE_OPTIONS; do
    /sbin/ethtool —offload "$IFACE" "$TOE_OPTION" off || true
  done
done
