From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 01/11] fs: add O_BENEATH_ONLY flag to openat(2)
Date: Tue, 8 Jul 2014 05:07:02 -0700
Message-ID: <20140708120702.GB30459@infradead.org>
References: <1404124096-21445-1-git-send-email-drysdale@google.com>
 <1404124096-21445-2-git-send-email-drysdale@google.com>
 <CALCETrU=HLmw9n-DxPkFV1xP5wtzQ7-YF3-uao6YiGZODA9kdw@mail.gmail.com>
 <20140630154928.GB10375@google.com>
 <CALCETrWJ-rqDo8OvSZWPUt1806gObNtwVHvC4M6kfQgvd3Eg9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrWJ-rqDo8OvSZWPUt1806gObNtwVHvC4M6kfQgvd3Eg9w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Jun 30, 2014 at 08:53:01AM -0700, Andy Lutomirski wrote:
> > Wouldn't it need to be both O_BENEATH_ONLY (for openat()) and
> > AT_BENEATH_ONLY (for other *at() functions), like O_NOFOLLOW and
> > AT_SYMLINK_NOFOLLOW?  (I.e. aren't the AT_* flags in a different
> > numbering space than O_* flags?)
> >
> > Or am I misunderstanding?
> >
> 
> Ugh, you're probably right.  I wish openat had separate flags and
> atflags arguments.  Oh well.

There's two different AT_* namespaces.  The flags that most *at syscalls
has, and the the one for the dfd argument, which currently only contains
AT_FDCWD, although a new constant has recently been proposed to it.

Having an AT_BENEATH magic value for the dfd argument certainly feels
elegant to me, but seems to be against the language for openat in Posix:

"The openat() function shall be equivalent to the open() function except
in the case where path specifies a relative path. In this case the file
to be opened is determined relative to the directory associated with the
file descriptor fd instead of the current working directory. If the file
descriptor was opened without O_SEARCH, the function shall check whether
directory searches are permitted using the current permissions of the
directory underlying the file descriptor. If the file descriptor was
opened with O_SEARCH, the function shall not perform the check.

The oflag parameter and the optional fourth parameter correspond exactly
to the parameters of open().

If openat() is passed the special value AT_FDCWD in the fd parameter,
the current working directory shall be used and the behavior shall be
identical to a call to open()."
