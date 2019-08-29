From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: Re: [PATCH v2 bpf-next 1/3] capability: introduce CAP_BPF and
 CAP_TRACING
Date: Thu, 29 Aug 2019 15:36:42 +0200
Message-ID: <a5ef2f94-acca-eb66-b48c-899494a9f8d0@6wind.com>
References: <20190829051253.1927291-1-ast@kernel.org>
Reply-To: nicolas.dichtel@6wind.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190829051253.1927291-1-ast@kernel.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <ast@kernel.org>, luto@amacapital.net
Cc: davem@davemloft.net, peterz@infradead.org, rostedt@goodmis.org, netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Le 29/08/2019 à 07:12, Alexei Starovoitov a écrit :
[snip]
> CAP_BPF and CAP_NET_ADMIN together allow the following:
> - Attach to cgroup-bpf hooks and query
> - skb, xdp, flow_dissector test_run command
> 
> CAP_NET_ADMIN allows:
> - Attach networking bpf programs to xdp, tc, lwt, flow dissector
I'm not sure to understand the difference between these last two points.
But, with the current kernel, CAP_NET_ADMIN is not enough to attach bpf prog
with tc and it's still not enough after your patch.
The following command is rejected:
$ tc filter add dev eth0 ingress matchall action bpf obj ./tc_test_kern.o sec test

Prog section 'test' rejected: Operation not permitted (1)!
 - Type:         4
 - Instructions: 22 (0 over limit)
 - License:      GPL

Verifier analysis:

Error fetching program/map!
bad action parsing
parse_action: bad value (5:bpf)!
Illegal "action"
$


Like Andy, I'm also wondering about the backward compatibility. With my current
docker, I'm able to play with tc bpf with CAP_SYS_ADMIN. But if I update my
kernel with your patches, CAP_SYS_ADMIN doesn't allow anymore that and CAP_BPF
is not implemented in my current docker, thus I cannot give the correct
capabilities. In other words, an old docker cannot run on a new kernel.

Regards,
Nicolas
