From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [PATCH ghak90 (was ghak32) V4 03/10] audit: log container info
 of syscalls
Date: Thu, 25 Oct 2018 13:38:30 -0400
Message-ID: <20181025173830.4yklhnrydt5qvr67@madcap2.tricolour.ca>
References: <cover.1533065887.git.rgb@redhat.com>
 <34017c395d03a213d6b0d49b9964429bd32b283d.1533065887.git.rgb@redhat.com>
 <CAHC9VhSv4hWGHiaaOfuBrRQKdp2YG5RtqXQbFXg7j7LNEhO2XQ@mail.gmail.com>
 <20181024151439.lavhanabsyxdrdvo@madcap2.tricolour.ca>
 <CAHC9VhRF1vsxM-k0Lw-9NqS9b9rgXRRBu0tq4ajdFpMqUxiH4A@mail.gmail.com>
 <20181025004255.zl7p7j6gztouh2hh@madcap2.tricolour.ca>
 <20181025080638.771621a3@ivy-bridge>
 <CAHC9VhR02siURgadQs0EikcOm0d_TPAi4jJYCx4NkA=wQ5rjSA@mail.gmail.com>
 <20181025122732.4j4rbychjse3gemt@madcap2.tricolour.ca>
 <20181025175745.5b2b13e9@ivy-bridge>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181025175745.5b2b13e9@ivy-bridge>
Sender: linux-kernel-owner@vger.kernel.org
To: Steve Grubb <sgrubb@redhat.com>
Cc: Paul Moore <paul@paul-moore.com>, simo@redhat.com, carlos@redhat.com, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-audit@redhat.com, netfilter-devel@vger.kernel.org, ebiederm@xmission.com, luto@kernel.org, netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>, Serge Hallyn <serge@hallyn.com>, viro@zeniv.linux.org.uk
List-Id: linux-api@vger.kernel.org

On 2018-10-25 17:57, Steve Grubb wrote:
> On Thu, 25 Oct 2018 08:27:32 -0400
> Richard Guy Briggs <rgb@redhat.com> wrote:
> 
> > On 2018-10-25 06:49, Paul Moore wrote:
> > > On Thu, Oct 25, 2018 at 2:06 AM Steve Grubb <sgrubb@redhat.com>
> > > wrote:  
> > > > On Wed, 24 Oct 2018 20:42:55 -0400
> > > > Richard Guy Briggs <rgb@redhat.com> wrote:  
> > > > > On 2018-10-24 16:55, Paul Moore wrote:  
> > > > > > On Wed, Oct 24, 2018 at 11:15 AM Richard Guy Briggs
> > > > > > <rgb@redhat.com> wrote:  
> > > > > > > On 2018-10-19 19:16, Paul Moore wrote:  
> > > > > > > > On Sun, Aug 5, 2018 at 4:32 AM Richard Guy Briggs
> > > > > > > > <rgb@redhat.com> wrote:  
> > > 
> > > ...
> > >   
> > > > > > > > > +/*
> > > > > > > > > + * audit_log_contid - report container info
> > > > > > > > > + * @tsk: task to be recorded
> > > > > > > > > + * @context: task or local context for record
> > > > > > > > > + * @op: contid string description
> > > > > > > > > + */
> > > > > > > > > +int audit_log_contid(struct task_struct *tsk,
> > > > > > > > > +                            struct audit_context
> > > > > > > > > *context, char *op) +{
> > > > > > > > > +       struct audit_buffer *ab;
> > > > > > > > > +
> > > > > > > > > +       if (!audit_contid_set(tsk))
> > > > > > > > > +               return 0;
> > > > > > > > > +       /* Generate AUDIT_CONTAINER record with
> > > > > > > > > container ID */
> > > > > > > > > +       ab = audit_log_start(context, GFP_KERNEL,
> > > > > > > > > AUDIT_CONTAINER);
> > > > > > > > > +       if (!ab)
> > > > > > > > > +               return -ENOMEM;
> > > > > > > > > +       audit_log_format(ab, "op=%s contid=%llu",
> > > > > > > > > +                        op, audit_get_contid(tsk));
> > > > > > > > > +       audit_log_end(ab);
> > > > > > > > > +       return 0;
> > > > > > > > > +}
> > > > > > > > > +EXPORT_SYMBOL(audit_log_contid);  
> > > > > > > >
> > > > > > > > As discussed in the previous iteration of the patch, I
> > > > > > > > prefer AUDIT_CONTAINER_ID here over AUDIT_CONTAINER.  If
> > > > > > > > you feel strongly about keeping it as-is with
> > > > > > > > AUDIT_CONTAINER I suppose I could live with that, but it
> > > > > > > > is isn't my first choice.  
> > > > > > >
> > > > > > > I don't have a strong opinion on this one, mildly
> > > > > > > preferring the shorter one only because it is shorter.  
> > > > > >
> > > > > > We already have multiple AUDIT_CONTAINER* record types, so it
> > > > > > seems as though we should use "AUDIT_CONTAINER" as a prefix
> > > > > > of sorts, rather than a type itself.  
> > > > >
> > > > > I'm fine with that.  I'd still like to hear Steve's input.  He
> > > > > had stronger opinions than me.  
> > > >
> > > > The creation event should be separate and distinct from the
> > > > continuing use when its used as a supplemental record. IOW,
> > > > binding the ID to a container is part of the lifecycle and needs
> > > > to be kept distinct.  
> > > 
> > > Steve's comment is pretty ambiguous when it comes to AUDIT_CONTAINER
> > > vs AUDIT_CONTAINER_ID, but one could argue that AUDIT_CONTAINER_ID
> > > helps distinguish the audit container id marking record and gets to
> > > what I believe is the spirit of Steve's comment.  Taking this in
> > > context with my previous remarks, let's switch to using
> > > AUDIT_CONTAINER_ID.  
> > 
> > I suspect Steve is mixing up AUDIT_CONTAINER_OP with
> > AUDIT_CONTAINER_ID, confusing the fact that they are two seperate
> > records.  As a summary, the suggested records are:
> > 	CONTAINER_OP	audit container identifier creation
> > 	CONTAINER	audit container identifier aux record to an
> > event
> > 
> > and what Paul is suggesting (which is fine by me) is:
> > 	CONTAINER_OP	audit container identifier creation event
> > 	CONTAINER_ID	audit container identifier aux record to
> > an event
> > 
> > Steve, please indicate you are fine with this.
> 
> I thought it was:

It *was*.  It was changed at Paul's request in this v3 thread:
	https://www.redhat.com/archives/linux-audit/2018-July/msg00087.html

And listed in the examples and changelog to this v4 patchset:
	https://www.redhat.com/archives/linux-audit/2018-July/msg00178.html

It is also listed in this userspace patchset update v4 (which should
also have had a changelog added to it, note to self...):
	https://www.redhat.com/archives/linux-audit/2018-July/msg00189.html

I realize it is hard to keep up with all the detail changes in these
patchsets...

> CONTAINER_ID audit container identifier creation event
> CONTAINER audit container identifier aux record to an event
> 
> Or vice versa. Don't mix up creation of the identifier with operations.

Exactly what I'm trying to avoid...  Worded another way: "Don't mix up
the creation operation with routine reporting of the identifier in
events."  Steve, can you and Paul discuss and agree on what they should
be called?  I don't have a horse in this race, but I need to record the
result of that run.  ;-)

> -Steve

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635
