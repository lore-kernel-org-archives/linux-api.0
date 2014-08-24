From: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 1/8] namespaces: assign each namespace instance a
 serial number
Date: Sun, 24 Aug 2014 16:38:27 -0400
Message-ID: <20140824203827.GI9003@madcap2.tricolour.ca>
References: <cover.1408581429.git.rgb@redhat.com>
 <cover.1408581429.git.rgb@redhat.com>
 <d5bfd81a219c5c45c910494d6a3478ce83052e1f.1408581429.git.rgb@redhat.com>
 <87ioljs968.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87ioljs968.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 14/08/23, Eric W. Biederman wrote:
> Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
> 
> > Generate and assign a serial number per namespace instance since boot.
> >
> > Use a serial number per namespace (unique across one boot of one kernel)
> > instead of the inode number (which is claimed to have had the right to change
> > reserved and is not necessarily unique if there is more than one proc fs) to
> > uniquely identify it per kernel boot.
> 
> This approach is just broken.
> 
> For this to work with migration (aka criu) you need to implement a
> namespace of namespaces.  You haven't done this, and therefore
> such an interface will break existing userspace.
> 
> Inside of audit I can understand not caring about these issues,
> but you go foward and expose these serial numbers in proc,
> and generally make this infrastructure available to others.
> 
> The deep issue with migration is that we move tasks from one machine
> from another and on the destination machine we need to have all of the
> same global identifiers for software to function properly.
> 
> My weasel words around the proc inode numbers is to preserve to allow us
> room to be able to restore those ids if it every becomes relevant for
> migration.

What do you do if the inode number is already in use on the target host?

> That is the proc inode numbers (technically) live in a pid namespace,
> (aka a mount of proc).  So depending on the pid namespace you are in
> or the mount of proc you look in the numbers could change.
> 
> Qualifications like that must exist to have a prayer of ever supporting
> process migration in the crazy corner cases where people start caring
> about inode numbers.
> 
> We currently don't and inode numbers for a namespace will never change
> after a namespace is created.  So I think you really are ok using the
> proc inode numbers.  I am happy declaring by fiat that the inode numbers
> that audit uses are the numbers connected to the initial pid namespace.

But once a namespace/container is migrated, it is a different audit that
is looking at it (unless we create an audit manager or entity that
functions at the level of a container manager), so audit should not care.

> At a fairly basic level anything that is used to identify namespaces for
> any general purpose use needs to have most if not all of the same
> properties of the proc inode numbers.  The most important of which is
> being tied to some context/namespace so there is a ability if we ever
> need it to migrate those numbers from one machine to another.

Sooo...  does it make any sense to have those inode or serial numbers be
blank inside the namespace/container itself, but only visible to its
manager outside the container (unless it is the initial namespace)?

> Eric
> 
> > diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
> > index 8e78110..93cb380 100644
> > --- a/kernel/nsproxy.c
> > +++ b/kernel/nsproxy.c
> > @@ -41,6 +41,23 @@ struct nsproxy init_nsproxy = {
> >  #endif
> >  };
> >  
> > +/**
> > + * ns_serial - compute a serial number for the namespace
> > + *
> > + * Compute a serial number for the namespace to uniquely identify it in
> > + * audit records.
> > + */
> > +long long ns_serial(void)
> > +{
> > +	static atomic64_t serial = ATOMIC_INIT(4); /* reserved for IPC, UTS, user, PID */
> > +	long long ret;
> > +
> > +	ret = atomic64_add_return(1, &serial);
> > +	BUG_ON(!ret);
> > +
> > +	return ret;
> > +}
> > +
> >  static inline struct nsproxy *create_nsproxy(void)
> >  {
> >  	struct nsproxy *nsproxy;
> 
> --
> Linux-audit mailing list
> Linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> https://www.redhat.com/mailman/listinfo/linux-audit

- RGB

--
Richard Guy Briggs <rbriggs-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
