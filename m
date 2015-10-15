From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v4 71/79] include/uapi/linux/fuse.h: use linux/types.h
 also in userspace
Date: Thu, 15 Oct 2015 21:25:30 +0200
Message-ID: <CAJfpegtYhwMW7vBPXG02fuijfsv3cGCwe9z=LWE56jKqvJwDMw@mail.gmail.com>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
	<20151015174154.GZ6104@lakka.kapsi.fi>
	<CAJfpegtSK-ttDXN+vz+yzsU9P1m7fDCn2VwXfHyJuWL6-O-g3g@mail.gmail.com>
	<9560422.ZpOrhsmRxt@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9560422.ZpOrhsmRxt@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, Kernel Mailing List <linux-kernel@vger.kernel.org>, fuse-devel <fuse-devel@lists.sourceforge.net>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 15, 2015 at 8:59 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 15 October 2015 20:32:45 Miklos Szeredi wrote:
>> > In my other patches I got review comments that kernel headers should not
>> > use <stdint.h> and also Documentation/CodingStyle section 5 says:
>> >
>> >  (e) Types safe for use in userspace.
>> >
>> >      In certain structures which are visible to userspace, we cannot
>> >      require C99 types and cannot use the 'u32' form above. Thus, we
>> >      use __u32 and similar types in all structures which are shared
>> >      with userspace.
>>
>> Ok, if you cannot require C99, then the __uXX types are the way to go.
>> But for the fuse API we *can* use C99 types, nothing preventing us
>> from doing it.
>
> What the sentence above means is that you should not rely on the
> user including <stdint.h> before including a kernel header, and
> that kernel headers are not allowed to include <stdint.h> themselves,
> because that would break any pre-C99 user space that defines types
> with the same names in their own headers and that relies on that
> header not to be included implicitly.
>
> It's possible that it has never been a problem for the fuse headers,
> but it has been a problem for other headers in the past and what
> Mikko is trying to achieve is to ensure that none of the kernel
> headers do this so we can make it an error in 'make headers_install'.

"in some cases including <stdint.h> might be a problem" is not a very
strong argument in favour of making it an error.  And since it would
be a step backwards for the fuse header I object to making it an
error.

If this is really such a big issue, then why not make it a warning
(and add a mechanism to silence that warning)?

Thanks,
Miklos
