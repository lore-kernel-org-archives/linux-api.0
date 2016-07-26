From: Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH 0/5 RFC] Add an interface to discover relationships
	between namespaces
Date: Mon, 25 Jul 2016 19:07:36 -0700
Message-ID: <20160726020735.GB23617@outlook.office365.com>
References: <1468520419-28220-1-git-send-email-avagin@openvz.org>
	<CANaxB-xw_xBUq=0uT14ANv-jfg2NsGaPy=jyDO9=yF03_7toSw@mail.gmail.com>
	<87poq3liyq.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87poq3liyq.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, "criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org" <criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Jul 24, 2016 at 12:10:21AM -0500, Eric W. Biederman wrote:
> Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> writes:
> 
> > Hello,
> >
> > I forgot to add --cc-cover for git send-email, so everyone who is in
> > Cc got only a cover letter. All messages were sent in mail lists.
> >
> > Sorry for inconvenience.
> 
> Mostly the code looked sensible.  But I had a couple of issues.
> Resend this in September (when the merge window is closed and I am back
> from vacation) and I will give this a thorough review and get this
> merged.  Or possibly next week if Linus releases another -rc

Eric, thank you for the detailed comments. I will rework this series and
send it after the merge window.

> 
> > On Thu, Jul 14, 2016 at 11:20 AM, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> wrote:
> >> Each namespace has an owning user namespace and now there is not way
> >> to discover these relationships.
> >>
> >> Pid and user namepaces are hierarchical. There is no way to discover
> >> parent-child relationships too.
> >>
> >> Why we may want to know relationships between namespaces?
> >>
> >> One use would be visualization, in order to understand the running system.
> >> Another would be to answer the question: what capability does process X have to
> >> perform operations on a resource governed by namespace Y?
> >>
> >> One more use-case (which usually called abnormal) is checkpoint/restart.
> >> In CRIU we age going to dump and restore nested namespaces.
> >>
> >> There [1] was a discussion about which interface to choose to determing
> >> relationships between namespaces.
> >>
> >> Eric suggested to add two ioctl-s [2]:
> >>> Grumble, Grumble.  I think this may actually a case for creating ioctls
> >>> for these two cases.  Now that random nsfs file descriptors are bind
> >>> mountable the original reason for using proc files is not as pressing.
> >>>
> >>> One ioctl for the user namespace that owns a file descriptor.
> >>> One ioctl for the parent namespace of a namespace file descriptor.
> >>
> >> Here is an implementaions of these ioctl-s.
> >>
> >> [1] https://lkml.org/lkml/2016/7/6/158
> >> [2] https://lkml.org/lkml/2016/7/9/101
> >>
> >> Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
> >> Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
> >> Cc: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> Cc: "W. Trevor King" <wking-vJI2gpByivqcqzYg7KEe8g@public.gmane.org>
> >> Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
> >> Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> 
> 
> Eric
