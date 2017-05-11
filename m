From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH] fs: add an ioctl to get an owning userns for a superblock
Date: Wed, 10 May 2017 20:24:00 -0500
Message-ID: <87efvwkwy7.fsf@xmission.com>
References: <20170509231938.6467-1-avagin@openvz.org>
	<87k25psg7b.fsf@xmission.com>
	<20170511001526.GA7992@outlook.office365.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20170511001526.GA7992-1ViLX0X+lBJGNQ1M2rI3KwRV3xvJKrda@public.gmane.org> (Andrei Vagin's
	message of "Wed, 10 May 2017 17:15:27 -0700")
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Andrei Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Andrei Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Andrei Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> writes:

> On Tue, May 09, 2017 at 07:34:00PM -0500, Eric W. Biederman wrote:
>> Andrei Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> writes:
>> 
>> > The introduced ioctl returns a file descriptor that refers to a owning
>> > user namespace for a superblock which is associated with a target file
>> > descriptor.
>> >
>> > EPERM is returned if the current process doesn't have CAP_SYS_ADMIN in
>> > the returned user namespace.
>> >
>> > This information is required to dump and restore mount namespaces. We
>> > need to know to which user namespace a superblock is belonged to.
>> >
>> > We already have the SIOCGSKNS ioctl for sockets to get a network
>> > namespace, so it looks reasonable to use the same interface for
>> > superblocks too.
>> >
>> > This functionality can be useful for users in order to understand
>> > a running system.
>> 
>> This will probably work.  And the capability check eases any concerns
>> I might have that this would be a trivial information leak.
>> 
>> That said can we hold off just a little bit.  If open_fs work actually
>> turns into a real interface that would seem to be the perfect place
>> to stick this functionality.
>
> Sure, we can. Do you know any place where to read more information about
> open_fs? I think I have heared a few times about this idea, but it would be
> good to get more details.


Look for David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> recent patches on lkml he
has implemented an initial rfc for it.

Eric
