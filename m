From: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org (J. Bruce Fields)
Subject: Re: [RFC v6 03/40] vfs: Add MAY_DELETE_SELF and MAY_DELETE_CHILD
 permission flags
Date: Fri, 28 Aug 2015 17:57:58 -0400
Message-ID: <20150828215758.GD23326@fieldses.org>
References: <1438689218-6921-1-git-send-email-agruenba@redhat.com>
 <1438689218-6921-4-git-send-email-agruenba@redhat.com>
 <CALCETrUoBnPyEGExpoDzHOCgnHh5=a1ROALmb63LLJZG+L=aQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrUoBnPyEGExpoDzHOCgnHh5=a1ROALmb63LLJZG+L=aQA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Andreas Gruenbacher <andreas.gruenbacher-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Aug 28, 2015 at 02:36:15PM -0700, Andy Lutomirski wrote:
> On Tue, Aug 4, 2015 at 4:53 AM, Andreas Gruenbacher
> <andreas.gruenbacher-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > Normally, deleting a file requires write and execute access to the parent
> > directory.  With Richacls, a process with MAY_DELETE_SELF access to a file
> > may delete the file even without write access to the parent directory.
> >
> > To support that, pass the MAY_DELETE_CHILD mask flag to inode_permission()
> > when checking for delete access inside a directory, and MAY_DELETE_SELF
> > when checking for delete access to a file itelf.
> >
> > The MAY_DELETE_SELF permission does not override the sticky directory
> > check.  It probably should.
> 
> Silly question from the peanut gallery: is there any such thing as
> opening an fd pointing at a file such that the "open file description"
> (i.e. the struct file) captures the right to delete the file?
> 
> IOW do we need FMODE_DELETE_SELF?

I guess FMODE_READ and _WRITE make sense because we pass file
descriptors to read() and write().  But we don't have a way to pass a
file descriptor to an operation that deletes a file.

(I think Windows may be different in both respects, it might be
interesting to compare, but I really don't understand how it works...).

--b.
