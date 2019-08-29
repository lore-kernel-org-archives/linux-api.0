From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/3] capability: introduce CAP_BPF and
 CAP_TRACING
Date: Thu, 29 Aug 2019 14:10:55 -0700
Message-ID: <20190829211053.5ani4al6mnhvvk5o@ast-mbp.dhcp.thefacebook.com>
References: <20190829051253.1927291-1-ast@kernel.org>
 <87ef14iffx.fsf@toke.dk>
 <20190829172410.j36gjxt6oku5zh6s@ast-mbp.dhcp.thefacebook.com>
 <87imqfhmo2.fsf@toke.dk>
 <20190829222530.3c6163ac@carbon>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190829222530.3c6163ac@carbon>
Sender: netdev-owner@vger.kernel.org
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>, Alexei Starovoitov <ast@kernel.org>, luto@amacapital.net, davem@davemloft.net, peterz@infradead.org, rostedt@goodmis.org, netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Aug 29, 2019 at 10:25:30PM +0200, Jesper Dangaard Brouer wrote:
> On Thu, 29 Aug 2019 20:05:49 +0200
> Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> 
> > Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> > 
> > > On Thu, Aug 29, 2019 at 09:44:18AM +0200, Toke Høiland-Jørgensen wrote:  
> > >> Alexei Starovoitov <ast@kernel.org> writes:
> > >>   
> > >> > CAP_BPF allows the following BPF operations:
> > >> > - Loading all types of BPF programs
> > >> > - Creating all types of BPF maps except:
> > >> >    - stackmap that needs CAP_TRACING
> > >> >    - devmap that needs CAP_NET_ADMIN
> > >> >    - cpumap that needs CAP_SYS_ADMIN  
> > >> 
> > >> Why CAP_SYS_ADMIN instead of CAP_NET_ADMIN for cpumap?  
> > >
> > > Currently it's cap_sys_admin and I think it should stay this way
> > > because it creates kthreads.  
> > 
> > Ah, right. I can sorta see that makes sense because of the kthreads, but
> > it also means that you can use all of XDP *except* cpumap with
> > CAP_NET_ADMIN+CAP_BPF. That is bound to create confusion, isn't it?
>  
> Hmm... I see 'cpumap' primarily as a network stack feature.  It is about
> starting the network stack on a specific CPU, allocating and building
> SKBs on that remote CPU.  It can only be used together with XDP_REDIRECT.
> I would prefer CAP_NET_ADMIN like the devmap, to keep the XDP
> capabilities consistent.

I don't mind relaxing cpumap to cap_net_admin.
Looking at the reaction to the rest of the set. I'd rather discuss it
and do it later after basic cap_bpf is in.
