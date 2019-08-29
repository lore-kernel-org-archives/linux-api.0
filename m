From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH v2 bpf-next 1/3] capability: introduce CAP_BPF and
 CAP_TRACING
Date: Thu, 29 Aug 2019 22:25:30 +0200
Message-ID: <20190829222530.3c6163ac@carbon>
References: <20190829051253.1927291-1-ast@kernel.org>
        <87ef14iffx.fsf@toke.dk>
        <20190829172410.j36gjxt6oku5zh6s@ast-mbp.dhcp.thefacebook.com>
        <87imqfhmo2.fsf@toke.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <87imqfhmo2.fsf@toke.dk>
Sender: netdev-owner@vger.kernel.org
To: Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>, Alexei Starovoitov <ast@kernel.org>, luto@amacapital.net, davem@davemloft.net, peterz@infradead.org, rostedt@goodmis.org, netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org, brouer@redhat.com
List-Id: linux-api@vger.kernel.org

On Thu, 29 Aug 2019 20:05:49 +0200
Toke Høiland-Jørgensen <toke@redhat.com> wrote:

> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> 
> > On Thu, Aug 29, 2019 at 09:44:18AM +0200, Toke Høiland-Jørgensen wrote:  
> >> Alexei Starovoitov <ast@kernel.org> writes:
> >>   
> >> > CAP_BPF allows the following BPF operations:
> >> > - Loading all types of BPF programs
> >> > - Creating all types of BPF maps except:
> >> >    - stackmap that needs CAP_TRACING
> >> >    - devmap that needs CAP_NET_ADMIN
> >> >    - cpumap that needs CAP_SYS_ADMIN  
> >> 
> >> Why CAP_SYS_ADMIN instead of CAP_NET_ADMIN for cpumap?  
> >
> > Currently it's cap_sys_admin and I think it should stay this way
> > because it creates kthreads.  
> 
> Ah, right. I can sorta see that makes sense because of the kthreads, but
> it also means that you can use all of XDP *except* cpumap with
> CAP_NET_ADMIN+CAP_BPF. That is bound to create confusion, isn't it?
 
Hmm... I see 'cpumap' primarily as a network stack feature.  It is about
starting the network stack on a specific CPU, allocating and building
SKBs on that remote CPU.  It can only be used together with XDP_REDIRECT.
I would prefer CAP_NET_ADMIN like the devmap, to keep the XDP
capabilities consistent.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
