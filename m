From: Mike Frysinger <vapier-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH] groups: don't return unmapped gids in getgroups(2)
Date: Fri, 17 Feb 2017 14:42:42 -0500
Message-ID: <CAAbOScmsPice+1ttz=hQ4c+eGYR2jdaJxx_AM17rx_-=dnDjcw@mail.gmail.com>
References: <20170216174750.4995-1-asarai@suse.de>
	<87a89mm213.fsf@xmission.com>
	<84f5d2eb-8686-8acd-8116-038585c97b03@suse.de>
	<CALCETrVQou93PpYjKTtPGcs-uyYZ6T+v6j+5oy937GNXpKuP-A@mail.gmail.com>
	<6ab9118c-0476-99c8-cfbd-d3f5d378255e@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <6ab9118c-0476-99c8-cfbd-d3f5d378255e-l3A5Bk7waGM@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 17, 2017 at 12:53 PM, Aleksa Sarai wrote:
> >>>> One thing overlooked by commit 9cc46516ddf4 ("userns: Add a knob to
> >>>> disable setgroups on a per user namespace basis") is that because
> >>>> setgroups(2) no longer works in user namespaces it doesn't make any
> >>>> sense to be returning weird group IDs that the process cannot do
> >>>> anything with.
> >>>
> >>>
> >
> >> bool DropPrivileges()
> >> {
> >>         /* ... */
> >>       // Verify that the user isn't still in any supplementary groups
> >
> > But the user *is* still in a supplementary group.  Your proposed
> > change would break the intent of this code.
>
> I was about to say that "being in an unmapped supplementary group does
> not count as privileges", but decided to test it first and realised that
> this is not true? How is this not a blatant security vulnerability?

whether they're mapped is irrelevant.  if you make modifications to
the FS, the permission check counts against the meaning of the ids in
the parent namespaces.  otherwise your argument is like saying "i
mapped my UID to 0 in this new usernamespace, so how is that not a
blatant security vuln".

if you started out with access to the group, then keeping that access
doesn't grant you any new privs you didn't already have.

> % touch somefile
> % chmod 660 somefile
> % sudo chown root:wheel somefile
> % unshare -r
> % cat somefile
> % # no EACCES...

you didn't show `id` before the `unshare`.  if you're already in the
wheel group, what you've shown here is not a bug.
-mike
