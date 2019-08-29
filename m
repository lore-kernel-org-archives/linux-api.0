From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/3] capability: introduce CAP_BPF and
 CAP_TRACING
Date: Thu, 29 Aug 2019 10:24:11 -0700
Message-ID: <20190829172410.j36gjxt6oku5zh6s@ast-mbp.dhcp.thefacebook.com>
References: <20190829051253.1927291-1-ast@kernel.org>
 <87ef14iffx.fsf@toke.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87ef14iffx.fsf@toke.dk>
Sender: netdev-owner@vger.kernel.org
To: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc: Alexei Starovoitov <ast@kernel.org>, luto@amacapital.net, davem@davemloft.net, peterz@infradead.org, rostedt@goodmis.org, netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Aug 29, 2019 at 09:44:18AM +0200, Toke Høiland-Jørgensen wrote:
> Alexei Starovoitov <ast@kernel.org> writes:
> 
> > CAP_BPF allows the following BPF operations:
> > - Loading all types of BPF programs
> > - Creating all types of BPF maps except:
> >    - stackmap that needs CAP_TRACING
> >    - devmap that needs CAP_NET_ADMIN
> >    - cpumap that needs CAP_SYS_ADMIN
> 
> Why CAP_SYS_ADMIN instead of CAP_NET_ADMIN for cpumap?

Currently it's cap_sys_admin and I think it should stay this way
because it creates kthreads.
