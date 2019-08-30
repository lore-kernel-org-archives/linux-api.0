From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: Re: [PATCH v2 bpf-next 2/3] bpf: implement CAP_BPF
Date: Fri, 30 Aug 2019 17:19:02 +0200
Message-ID: <59ac111e-7ce7-5e00-32c9-9b55482fe701@6wind.com>
References: <20190829051253.1927291-1-ast@kernel.org>
 <20190829051253.1927291-2-ast@kernel.org>
 <ed8796f5-eaea-c87d-ddd9-9d624059e5ee@iogearbox.net>
 <20190829173034.up5g74onaekp53zd@ast-mbp.dhcp.thefacebook.com>
Reply-To: nicolas.dichtel@6wind.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190829173034.up5g74onaekp53zd@ast-mbp.dhcp.thefacebook.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>, Daniel Borkmann <daniel@iogearbox.net>
Cc: Alexei Starovoitov <ast@kernel.org>, luto@amacapital.net, davem@davemloft.net, peterz@infradead.org, rostedt@goodmis.org, netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Le 29/08/2019 à 19:30, Alexei Starovoitov a écrit :
[snip]
> These are the links that showing that k8 can delegates caps.
> Are you saying that you know of folks who specifically
> delegate cap_sys_admin and cap_net_admin _only_ to a container to run bpf in there?
> 
Yes, we need cap_sys_admin only to load bpf:
tc filter add dev eth0 ingress matchall action bpf obj ./tc_test_kern.o sec test

I'm not sure to understand why cap_net_admin is not enough to run the previous
command (ie why load is forbidden).

I want to avoid sys_admin, thus cap_bpf will be ok. But we need to manage the
backward compatibility.

Regards,
Nicolas
