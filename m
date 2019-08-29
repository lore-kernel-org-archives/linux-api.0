From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/3] capability: introduce CAP_BPF and
 CAP_TRACING
Date: Thu, 29 Aug 2019 10:25:40 -0700
Message-ID: <20190829172539.j4qnhokhdflvkfm2@ast-mbp.dhcp.thefacebook.com>
References: <20190829051253.1927291-1-ast@kernel.org>
 <a5ef2f94-acca-eb66-b48c-899494a9f8d0@6wind.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a5ef2f94-acca-eb66-b48c-899494a9f8d0@6wind.com>
Sender: netdev-owner@vger.kernel.org
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc: Alexei Starovoitov <ast@kernel.org>, luto@amacapital.net, davem@davemloft.net, peterz@infradead.org, rostedt@goodmis.org, netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Aug 29, 2019 at 03:36:42PM +0200, Nicolas Dichtel wrote:
> Le 29/08/2019 à 07:12, Alexei Starovoitov a écrit :
> [snip]
> > CAP_BPF and CAP_NET_ADMIN together allow the following:
> > - Attach to cgroup-bpf hooks and query
> > - skb, xdp, flow_dissector test_run command
> > 
> > CAP_NET_ADMIN allows:
> > - Attach networking bpf programs to xdp, tc, lwt, flow dissector
> I'm not sure to understand the difference between these last two points.
> But, with the current kernel, CAP_NET_ADMIN is not enough to attach bpf prog
> with tc and it's still not enough after your patch.
> The following command is rejected:
> $ tc filter add dev eth0 ingress matchall action bpf obj ./tc_test_kern.o sec test
> 
> Prog section 'test' rejected: Operation not permitted (1)!
>  - Type:         4
>  - Instructions: 22 (0 over limit)
>  - License:      GPL
> 
> Verifier analysis:
> 
> Error fetching program/map!
> bad action parsing
> parse_action: bad value (5:bpf)!
> Illegal "action"

because tc/iproute2 is doing load and attach.
Currently load needs cap_sys_admin and
attach needs cap_net_admin.
