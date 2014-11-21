From: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: kdbus: add node and filesystem implementation
Date: Fri, 21 Nov 2014 17:53:09 +0100
Message-ID: <CANq1E4T9nJSAC2VprUXpCdCFPE+mzNSEzi+z78HdYU_OiYC=wA@mail.gmail.com>
References: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org>
	<1416546149-24799-7-git-send-email-gregkh@linuxfoundation.org>
	<CALCETrW-RkhKa4n7X1HoPgmSuLV4V8YQ=FaSYVJ1YsHS=pJCSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrW-RkhKa4n7X1HoPgmSuLV4V8YQ=FaSYVJ1YsHS=pJCSQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi

On Fri, Nov 21, 2014 at 5:35 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> On Thu, Nov 20, 2014 at 9:02 PM, Greg Kroah-Hartman
> <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
>> From: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
>>
>> kdbusfs is a filesystem that will expose a fresh kdbus domain context
>> each time it is mounted. Per mount point, there will be a 'control'
>> node, which can be used to create buses. fs.c contains the
>> implementation of that pseudo-fs. Exported inodes of 'file' type have
>> their i_fop set to either kdbus_handle_control_ops or
>> kdbus_handle_ep_ops, depending on their type. The actual dispatching
>> of file operations is done from handle.c
>>
>> node.c is an implementation of a kdbus object that has an id and
>> children, organized in an R/B tree. The tree is used by the filesystem
>> code for lookup and iterator functions, and to deactivate children
>> once the parent is deactivated. Every inode exported by kdbusfs is
>> backed by a kdbus_node, hence it is embedded in struct kdbus_ep,
>> struct kdbus_bus and struct kdbus_domain.
>>
>> Signed-off-by: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
>> Signed-off-by: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> Signed-off-by: Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
>> Signed-off-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
>> ---
>
>
>> +
>> +static struct file_system_type fs_type = {
>> +       .name           = KBUILD_MODNAME "fs",
>> +       .owner          = THIS_MODULE,
>> +       .mount          = fs_super_mount,
>> +       .kill_sb        = fs_super_kill,
>> +};
>
> Does this want something like:
>
> .fs_flags = FS_USERNS_MOUNT

Yes, we should add that. Nice catch!

> This design may have the annoying property that, if a namespace-based
> sandbox wants to use kdbus itself, it will need to proxy anything from
> the parent that it wants to use.
>
> Is there a good reason why individual *busses* don't show up in the
> filesystem?  If they did, maybe they could be bind-mounted or
> otherwise arranged to cross namespace boundaries.

Buses show up as directories in kdbusfs. You can bind-mount them
anywhere you want and you will get access to the endpoints in there.

Thanks
David
