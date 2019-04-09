From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH ghak90 V6 05/10] audit: add contid support for signalling
 the audit daemon
Date: Tue, 9 Apr 2019 10:07:22 -0400
Message-ID: <CAHC9VhQ2DAfaHcSUoE3vTtSzGL5TtRuLZgGrt4TyG44pKuBD7g@mail.gmail.com>
References: <cover.1554732921.git.rgb@redhat.com> <baa5f3c6d4aa7f9fec903ebb51949f3ac743d067.1554732921.git.rgb@redhat.com>
 <CAFqZXNvZTb-OrCHugEc2TrW57EX_f_+absARpR1bUBN3_uavdQ@mail.gmail.com>
 <CAHC9VhRbxefdpTX5ct+1=uccv9b2GH+imDPPbB90RBWSjMcgbA@mail.gmail.com> <20190409134852.GB15660@hmswarspite.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190409134852.GB15660@hmswarspite.think-freely.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Ondrej Mosnacek <omosnace@redhat.com>, Richard Guy Briggs <rgb@redhat.com>, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, Steve Grubb <sgrubb@redhat.com>, David Howells <dhowells@redhat.com>, Simo Sorce <simo@redhat.com>, Eric Paris <eparis@parisplace.org>, "Serge E. Hallyn" <serge@hallyn.com>, "Eric W . Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 9, 2019 at 9:49 AM Neil Horman <nhorman@tuxdriver.com> wrote:
> On Tue, Apr 09, 2019 at 09:40:58AM -0400, Paul Moore wrote:
> > On Tue, Apr 9, 2019 at 8:58 AM Ondrej Mosnacek <omosnace@redhat.com> wrote:
> > >
> > > On Tue, Apr 9, 2019 at 5:40 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > Add audit container identifier support to the action of signalling the
> > > > audit daemon.
> > > >
> > > > Since this would need to add an element to the audit_sig_info struct,
> > > > a new record type AUDIT_SIGNAL_INFO2 was created with a new
> > > > audit_sig_info2 struct.  Corresponding support is required in the
> > > > userspace code to reflect the new record request and reply type.
> > > > An older userspace won't break since it won't know to request this
> > > > record type.
> > > >
> > > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > >
> > > This looks good to me.
> > >
> > > Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
> > >
> > > Although I'm wondering if we shouldn't try to future-proof the
> > > AUDIT_SIGNAL_INFO2 format somehow, so that we don't need to add
> > > another AUDIT_SIGNAL_INFO3 when the need arises to add yet-another
> > > identifier to it... The simplest solution I can come up with is to add
> > > a "version" field at the beginning (set to 2 initially), then v<N>_len
> > > at the beginning of data for version <N>. But maybe this is too
> > > complicated for too little gain...
> >
> > FWIW, I believe the long term solution to this is the fabled netlink
> > attribute approach that we haven't talked about in some time, but I
> > keep dreaming about (it has been mostly on the back burner becasue 1)
> > time and 2) didn't want to impact the audit container ID work).  While
> > I'm not opposed to trying to make things like this a bit more robust
> > by adding version fields and similar things, there are still so many
> > (so very many) problems with the audit kernel/userspace interface that
> > still need to be addressed.
>
> Agreed, this change as-is is in keeping with the message structure that audit
> has today, and so is ok with me, but the long term goal should be a conversion
> to netlink attributes for all audit messages.  Thats a big undertaking and
> should be addressed separately though.

You've likely missed all the conversations around this from some time
ago, but this is the direction I want us to go towards eventually, and
yes, this is a huge undertaking (much larger than the audit container
ID work) that will need to be done in stages.

The first step is moving away from audit_log_format() to an in-kernel
audit API that separates the data from the record format; I've got a
lot of ideas on that, but as I said earlier, it's mostly on the back
burner so it doesn't hold up the audit container ID work.

-- 
paul moore
www.paul-moore.com
