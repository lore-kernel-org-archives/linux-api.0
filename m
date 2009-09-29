From: "Serge E. Hallyn" <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v18 49/80] c/r: support for UTS namespace
Date: Tue, 29 Sep 2009 13:51:26 -0500
Message-ID: <20090929185126.GB13297@us.ibm.com>
References: <1253749920-18673-1-git-send-email-orenl@librato.com> <1253749920-18673-50-git-send-email-orenl@librato.com> <200909292213.21266@blacky.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <200909292213.21266-vlktAfmDCSZSq9BJjBFyUp/QNRX+jHPU@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nikita V. Youshchenko" <yoush-/llMDZXAvAOHXe+LvDLADg@public.gmane.org>
Cc: Oren Laadan <orenl-RdfvBDnrOixBDgjK7y7TUQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Dan Smith <danms-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Quoting Nikita V. Youshchenko (yoush-/llMDZXAvAOHXe+LvDLADg@public.gmane.org):
> > +static struct uts_namespace *do_restore_uts_ns(struct ckpt_ctx *ctx)
> > ...
> > +#ifdef CONFIG_UTS_NS
> > +	uts_ns = create_uts_ns();
> > +	if (!uts_ns) {
> > +		uts_ns = ERR_PTR(-ENOMEM);
> > +		goto out;
> > +	}
> > +	down_read(&uts_sem);
> > +	name = &uts_ns->name;
> > +	memcpy(name->sysname, h->sysname, sizeof(name->sysname));
> > +	memcpy(name->nodename, h->nodename, sizeof(name->nodename));
> > +	memcpy(name->release, h->release, sizeof(name->release));
> > +	memcpy(name->version, h->version, sizeof(name->version));
> > +	memcpy(name->machine, h->machine, sizeof(name->machine));
> > +	memcpy(name->domainname, h->domainname, sizeof(name->domainname));
> > +	up_read(&uts_sem);
> 
> Could you please explain what for is this down_read() / up_read() ?
> You operate only on local objects: 'name' points to just-created 
> uts_ns, 'h' is also local data.

Yup, good point, that looks unnecessary.

thanks,
-serge
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
