From: Eric Dumazet <edumazet@google.com>
Subject: Re: [net-next PATCH v3 4/8] net: Change return type of sk_busy_loop
 from bool to void
Date: Fri, 22 Mar 2019 05:59:03 -0700
Message-ID: <CANn89iJhzT4hkn38oK77J0L464eNgiXZmongFnRuRnSPcVnGbQ@mail.gmail.com>
References: <20170324164902.15226.48358.stgit@localhost.localdomain>
 <20170324170812.15226.97497.stgit@localhost.localdomain> <CALMXkpb3MfLbNoBgLJc0rgMDbPg9yOevKOiq9N8pzVw-aeNb3g@mail.gmail.com>
 <e532fdb97e142eca2484e5abbeca4c30d11fbad6.camel@redhat.com>
 <CAKgT0Uc68jsuPHKbxxFpeMCQAo2M69DhzA_XGw7Kvou4H3eHPg@mail.gmail.com>
 <CALMXkpZ_eB+aRx3+aKM5Bs4RwDfzPNX+XneESo2-yuMPjHV5-Q@mail.gmail.com> <0eb092b7ca67942f52e36c672d20f130f1d54e1e.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0eb092b7ca67942f52e36c672d20f130f1d54e1e.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Abeni <pabeni@redhat.com>
Cc: Christoph Paasch <christoph.paasch@gmail.com>, Alexander Duyck <alexander.duyck@gmail.com>, netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "Samudrala, Sridhar" <sridhar.samudrala@intel.com>, David Miller <davem@davemloft.net>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 22, 2019 at 3:33 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> Hi,
>
> On Thu, 2019-03-21 at 23:05 -0400, Christoph Paasch wrote:
> > On Thu, Mar 21, 2019 at 12:43 PM Alexander Duyck
> > <alexander.duyck@gmail.com> wrote:
> > > On Thu, Mar 21, 2019 at 2:45 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > > > The following - completely untested - should avoid the unbounded loop,
> > > > but it's not a complete fix, I *think* we should also change
> > > > sk_busy_loop_end() in a similar way, but that is a little more complex
> > > > due to the additional indirections.
> > >
> > > As far as sk_busy_loop_end we could look at just forking sk_busy_loop
> > > and writing a separate implementation for datagram sockets that uses a
> > > different loop_end function. It shouldn't take much to change since
> > > all we would need to do is pass a structure containing the sk and last
> > > pointers instead of just passing the sk directly as the loop_end
> > > argument.
> > >
> > > > Could you please test it?
> > > >
> > > > Any feedback welcome!
> > >
> > > The change below looks good to me.
> >
> > I just tried it out. Worked for me!
> >
> > You can add my Tested-by if you do a formal patch-submission:
> >
> > Tested-by: Christoph Paasch <cpaasch@apple.com>
>
> Thanks for testing!
>
> I'm trying to reproduce the issue locally, but I'm unable. I think that
> the current UDP implementation is not affected, as we always ensure
> sk_receive_queue is empty before busy polling.

But right after check is done we release the queue lock, so a packet might
come right after the test has been done.

> Unix sockets should not
> be affected, too, as busy polling should not have any effect there
> (sk_napi_id should be never >= MIN_NAPI_ID). Can you reproduce the
> issue on an unpatched, recent, upstream kernel?



>
> Can you please provide the syzkaller repro?
>
> Thanks,
>
> Paolo
>
>
>
>
>
