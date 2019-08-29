From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH v2 bpf-next 1/3] capability: introduce CAP_BPF and CAP_TRACING
Date: Thu, 29 Aug 2019 09:44:18 +0200
Message-ID: <87ef14iffx.fsf@toke.dk>
References: <20190829051253.1927291-1-ast@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190829051253.1927291-1-ast@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <ast@kernel.org>, luto@amacapital.net
Cc: davem@davemloft.net, peterz@infradead.org, rostedt@goodmis.org, netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Alexei Starovoitov <ast@kernel.org> writes:

> CAP_BPF allows the following BPF operations:
> - Loading all types of BPF programs
> - Creating all types of BPF maps except:
>    - stackmap that needs CAP_TRACING
>    - devmap that needs CAP_NET_ADMIN
>    - cpumap that needs CAP_SYS_ADMIN

Why CAP_SYS_ADMIN instead of CAP_NET_ADMIN for cpumap?

-Toke
