From: Florian Weimer <fw-d32yF4oPJVt0XxTmqZlbVQ@public.gmane.org>
Subject: Re: Hard-coding PTY device node numbers in userspace
Date: Sun, 19 Feb 2017 16:35:12 +0100
Message-ID: <87d1eechxr.fsf@mid.deneb.enyo.de>
References: <87bmu1jd0j.fsf@mid.deneb.enyo.de>
        <20170217181538.GA9346@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170217181538.GA9346-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org> (Greg KH's message of "Fri, 17
        Feb 2017 10:15:38 -0800")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Brauner <christian.brauner-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jslaby-IBi9RG/b67k@public.gmane.org
List-Id: linux-api@vger.kernel.org

* Greg KH:

> On Fri, Feb 17, 2017 at 12:02:52PM +0100, Florian Weimer wrote:
>> We want to reject PTY devices from other namespaces as valid input to
>> the ttyname and ttyname_r functions, while still providing a hint to
>> callers that the device is, in fact, a PTY.  Christian Brauner wrote a
>> glibc patch for this:
>> 
>>   <https://sourceware.org/ml/libc-alpha/2017-01/msg00531.html>
>> 
>> It hard-codes the major PTY device number range.  Is this feasible?
>> Is it part of the stable userspace ABI for the TTY subsystem?
>
> What major numbers are you using in the patch '2' and '3'?

I think there is just one patch, and the check looks like this:

  static inline int
  is_pty (struct stat64 *sb)
  {
    int m = major (sb->st_rdev);
    return (136 <= m && m <= 143);
  }

> And yes,
> major numbers are static and you should be fine to rely on them.  But
> can't you test that the device is a pty to verify it?

It's not entirely clear what exactly a PTY descriptor should be for
ttyname.  Going forward, we only want to treat descriptors for PTY
devices which can be accessed using /dev/pts paths in the current
namespace as PTYs.  Christian's patch adds a separate error code for
the case where the descriptor is a PTY, but it comes from a different
namespace.

I'm concerned that some software out there assumes that if standard
input is a PTY according to ttyname, it is safe to chown it.  There
have been security issues related to that a long time ago on some UNIX
systems, and I want us to be conservative here.
