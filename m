From: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH ghak32 V2 01/13] audit: add container id
Date: Thu, 29 Mar 2018 05:01:32 -0400
Message-ID: <20180329090132.r3qfomigkw3hbwbw@madcap2.tricolour.ca>
References: <cover.1521179281.git.rgb@redhat.com>
	<e284617ad667ad8f17958dd8babb87fe1b4d7205.1521179281.git.rgb@redhat.com>
	<20180328123912.49b11c98@lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180328123912.49b11c98-T1hC0tSOHrs@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Cc: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, madzcar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Linux-Audit Mailing List <linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 2018-03-28 12:39, Jonathan Corbet wrote:
> On Fri, 16 Mar 2018 05:00:28 -0400
> Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > Implement the proc fs write to set the audit container ID of a process,
> > emitting an AUDIT_CONTAINER record to document the event.
> 
> A little detail, but still...

I am understanding that you would prefer more context (as opposed to
operational detail) in the description, laying out the use case for this
patch(set)?

> > +static int audit_set_containerid_perm(struct task_struct *task, u64 containerid)
> > +{
> > +	struct task_struct *parent;
> > +	u64 pcontainerid, ccontainerid;
> > +
> > +	/* Don't allow to set our own containerid */
> > +	if (current == task)
> > +		return -EPERM;
> > +	/* Don't allow the containerid to be unset */
> > +	if (!cid_valid(containerid))
> > +		return -EINVAL;
> 
> I went looking for cid_valid(), but it turns out you don't add it until
> patch 5.  That, I expect, will not be good for bisectability (or patch
> review).

Nice catch, thanks Jon.  That is very likely another victim of a git
rebase to re-order afterthoughts in the right place.  I'll need to be
more careful of that class of bug, rethink my workflow, or script builds
to verify each commit is compilable.

> Thanks,
> 
> jon

- RGB

--
Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635
