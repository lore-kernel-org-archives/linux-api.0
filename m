From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [PATCH ghak90 V6 05/10] audit: add contid support for signalling
 the audit daemon
Date: Tue, 9 Apr 2019 09:53:04 -0400
Message-ID: <20190409135304.rgkcpgya6h3ciphy@madcap2.tricolour.ca>
References: <cover.1554732921.git.rgb@redhat.com>
 <baa5f3c6d4aa7f9fec903ebb51949f3ac743d067.1554732921.git.rgb@redhat.com>
 <CAFqZXNvZTb-OrCHugEc2TrW57EX_f_+absARpR1bUBN3_uavdQ@mail.gmail.com>
 <CAHC9VhRbxefdpTX5ct+1=uccv9b2GH+imDPPbB90RBWSjMcgbA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHC9VhRbxefdpTX5ct+1=uccv9b2GH+imDPPbB90RBWSjMcgbA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Moore <paul@paul-moore.com>
Cc: Ondrej Mosnacek <omosnace@redhat.com>, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, Steve Grubb <sgrubb@redhat.com>, David Howells <dhowells@redhat.com>, Simo Sorce <simo@redhat.com>, Eric Paris <eparis@parisplace.org>, "Serge E. Hallyn" <serge@hallyn.com>, "Eric W . Biederman" <ebiederm@xmission.com>, nhorman@tuxdriver.com
List-Id: linux-api@vger.kernel.org

On 2019-04-09 09:40, Paul Moore wrote:
> On Tue, Apr 9, 2019 at 8:58 AM Ondrej Mosnacek <omosnace@redhat.com> wrote:
> > On Tue, Apr 9, 2019 at 5:40 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > Add audit container identifier support to the action of signalling the
> > > audit daemon.
> > >
> > > Since this would need to add an element to the audit_sig_info struct,
> > > a new record type AUDIT_SIGNAL_INFO2 was created with a new
> > > audit_sig_info2 struct.  Corresponding support is required in the
> > > userspace code to reflect the new record request and reply type.
> > > An older userspace won't break since it won't know to request this
> > > record type.
> > >
> > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> >
> > This looks good to me.
> >
> > Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
> >
> > Although I'm wondering if we shouldn't try to future-proof the
> > AUDIT_SIGNAL_INFO2 format somehow, so that we don't need to add
> > another AUDIT_SIGNAL_INFO3 when the need arises to add yet-another
> > identifier to it... The simplest solution I can come up with is to add
> > a "version" field at the beginning (set to 2 initially), then v<N>_len
> > at the beginning of data for version <N>. But maybe this is too
> > complicated for too little gain...
> 
> FWIW, I believe the long term solution to this is the fabled netlink
> attribute approach that we haven't talked about in some time, but I
> keep dreaming about (it has been mostly on the back burner becasue 1)
> time and 2) didn't want to impact the audit container ID work).  While
> I'm not opposed to trying to make things like this a bit more robust
> by adding version fields and similar things, there are still so many
> (so very many) problems with the audit kernel/userspace interface that
> still need to be addressed.

While this particular message type is used very infrequently, adding a
version field to every message type strikes me as a huge overhead for
the small likelihood of the format needing to change.

I'd prefer to just key it off the AUDIT_FEATURE_BITMAP or some other
easily detectable change in this distinguishing feature, such as the
presence of /proc/self/audit_containerid, which is what I've done in the
accompanying userspace patchset that I'm preparing to post that works
with this change.

Neil, you are right that netlink has useful mechanisms to help with this
sort of thing, but we're not quite there yet.

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635
