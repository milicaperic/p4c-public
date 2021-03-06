#include <core.p4>
#include <psa.p4>

struct EMPTY {
}

typedef bit<48> EthernetAddress;
header ethernet_t {
    EthernetAddress dstAddr;
    EthernetAddress srcAddr;
    EthernetAddress srcAddr2;
    EthernetAddress srcAddr3;
    bit<16>         etherType;
}

parser MyIP(packet_in buffer, out ethernet_t eth, inout EMPTY b, in psa_ingress_parser_input_metadata_t c, in EMPTY d, in EMPTY e) {
    state start {
        buffer.extract<ethernet_t>(eth);
        transition accept;
    }
}

parser MyEP(packet_in buffer, out EMPTY a, inout EMPTY b, in psa_egress_parser_input_metadata_t c, in EMPTY d, in EMPTY e, in EMPTY f) {
    state start {
        transition accept;
    }
}

control MyIC(inout ethernet_t a, inout EMPTY b, in psa_ingress_input_metadata_t c, inout psa_ingress_output_metadata_t d) {
    action a1(bit<48> param) {
        a.dstAddr = param;
    }
    action a2(bit<16> param) {
        a.etherType = param;
    }
    table tbl_idle_timeout {
        key = {
            a.srcAddr: exact @name("a.srcAddr") ;
        }
        actions = {
            NoAction();
            a1();
            a2();
        }
        psa_idle_timeout = PSA_IdleTimeout_t.NOTIFY_CONTROL;
        default_action = NoAction();
    }
    table tbl_no_idle_timeout {
        key = {
            a.srcAddr2: exact @name("a.srcAddr2") ;
        }
        actions = {
            NoAction();
            a1();
            a2();
        }
        psa_idle_timeout = PSA_IdleTimeout_t.NO_TIMEOUT;
        default_action = NoAction();
    }
    table tbl_no_idle_timeout_prop {
        key = {
            a.srcAddr2: exact @name("a.srcAddr2") ;
        }
        actions = {
            NoAction();
            a1();
            a2();
        }
        default_action = NoAction();
    }
    apply {
        tbl_idle_timeout.apply();
        tbl_no_idle_timeout.apply();
        tbl_no_idle_timeout_prop.apply();
    }
}

control MyEC(inout EMPTY a, inout EMPTY b, in psa_egress_input_metadata_t c, inout psa_egress_output_metadata_t d) {
    apply {
    }
}

control MyID(packet_out buffer, out EMPTY a, out EMPTY b, out EMPTY c, inout ethernet_t d, in EMPTY e, in psa_ingress_output_metadata_t f) {
    apply {
        buffer.emit<ethernet_t>(d);
    }
}

control MyED(packet_out buffer, out EMPTY a, out EMPTY b, inout EMPTY c, in EMPTY d, in psa_egress_output_metadata_t e, in psa_egress_deparser_input_metadata_t f) {
    apply {
    }
}

IngressPipeline<ethernet_t, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY>(MyIP(), MyIC(), MyID()) ip;

EgressPipeline<EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY>(MyEP(), MyEC(), MyED()) ep;

PSA_Switch<ethernet_t, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY>(ip, PacketReplicationEngine(), ep, BufferingQueueingEngine()) main;

