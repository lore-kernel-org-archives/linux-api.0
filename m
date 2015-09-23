From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [RFC v7 15/41] richacl: Automatic Inheritance
Date: Wed, 23 Sep 2015 09:55:44 -0400
Message-ID: <20150923135544.GA27083@fieldses.org>
References: <1441448856-13478-1-git-send-email-agruenba@redhat.com>
 <1441448856-13478-16-git-send-email-agruenba@redhat.com>
 <20150918184014.GB21506@fieldses.org>
 <CAHc6FU5mV9uVP9CjtDtKpJyTMRsn7hsArWXeKRp_xSeSPoCjnA@mail.gmail.com>
 <20150922015146.GA15960@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150922015146.GA15960-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Sep 21, 2015 at 09:51:46PM -0400, J. Bruce Fields wrote:
> On Mon, Sep 21, 2015 at 11:19:59PM +0200, Andreas Gruenbacher wrote:
> > 2015-09-18 20:40 GMT+02:00 J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>:
> > > On Sat, Sep 05, 2015 at 12:27:10PM +0200, Andreas Gruenbacher wrote:
> > >> Automatic Inheritance (AI) allows changes to the acl of a directory to
> > > In the above "file" sometimes means "any object" and somethings "a
> > > non-directory".  I can sort it out, but more consistent terminology
> > > would help.
> > 
> > Okay, I'll fix it.
> > 
> > >> Linux does not have a way of creating files without setting the file
> > >> permission bits, so all files created inside a directory with
> > >> RICHACL_AUTO_INHERIT set will have the RICHACL_PROTECTED flag set.  This
> > >> effectively disables Automatic Inheritance.
> > >>
> > >> Protocols which support creating files without specifying permissions
> > >> can explicitly clear the RICHACL_PROTECTED flag after creating a file
> > >> and reset the file masks to "undo" applying the create mode; see
> > >> richacl_compute_max_masks().  They should set the RICHACL_DEFAULTED
> > >> flag.  This is a workaround; a mechanism that would allow a process to
> > >> indicate to the kernel to ignore the create mode when there are
> > >> inherited permissions would fix this problem.
> > >
> > > Also, as you know: current nfsd has no way to create files without
> > > setting permissions.  And if we were to implement that it's unclear how
> > > many clients would actually use it (Windows clients are rare).  And of
> > > course Samba doesn't have the interfaces it would need.
> > >
> > > I think we should just drop this for now.  The rest of the richacl stuff
> > > is still useful without it.
> > 
> > Samba will hack around it and adjust the ACL after the create; that's
> > still better than not having Automatic Inheritance. Windows uses AI
> > all the time so AI is more important for Samba than for NFSv4.
> 
> Oh, OK, that makes sense.  Even just giving them a place to store the
> bits would be better than nothing.  So, ignore my objection there....

Oh, and

	Reviewed-by: J. Bruce Fields <bfields-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

--b.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
