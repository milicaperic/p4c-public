header_type simpleipv4_t {
    fields {
        version     : 4;
        ihl         : 4;
        diffserv    : 8;
        totalLen    : 16;
        id          : 16;
        flags       : 3;
        fragOffset  : 13;
        ttl         : 8;
        protocol    : 8;
        hdrChecksum : 16;
        srcAddr     : 32;
        dstAddr     : 32;
    }
}

header_type ipv4_t {
    fields {
        version     : 4;
        ihl         : 4;
        diffserv    : 8;
        totalLen    : 16;
        id          : 16;
        flags       : 3;
        fragOffset  : 13;
        ttl         : 8;
        protocol    : 8;
        hdrChecksum : 16;
        srcAddr     : 32;
        dstAddr     : 32;
        options_ipv4: *;
    }
    length          : (ihl << 2);
    max_length      : 60;
}

header ipv4_t h[2];
header simpleipv4_t sh[2];

parser start {
    extract(sh[next]);
    extract(sh[next]);
    extract(h[next]);
    extract(h[next]);
    return ingress;
}

control ingress {
}