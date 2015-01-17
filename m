From: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v3 00/13] Add kdbus implementation
Date: Fri, 16 Jan 2015 19:41:20 -0500
Message-ID: <CA+5PVA4sLgTFBgdfgBKzXeWbXOkPVCDwOOVDrefUSCU_srm8Kw@mail.gmail.com>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>
	<CA+5PVA7idthaLM_VTLdLEU=z=mbYnEkdQOSGSXqdJHJTNAHkzA@mail.gmail.com>
	<20150116221824.GA512@kroah.com>
	<54B9AC3E.9070105@zonque.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54B9AC3E.9070105-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Jan 16, 2015 at 7:26 PM, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org> wrote:
> Hi Josh,
>
> On 01/16/2015 11:18 PM, Greg Kroah-Hartman wrote:
>> On Fri, Jan 16, 2015 at 05:07:25PM -0500, Josh Boyer wrote:
>>> The code.google.com tree has commits
>>> from 2 days ago, but it still calls d_materialise_unique in fs.c
>>> whereas the patchset you've posted uses the correct d_splice_alias.
>>> So the code.google.com tree doesn't actually compile against 3.19-rcX.
>>>
>>> I'm confused where we're supposed to track things now.
>
> The code.google.com repository is where we do all the development, and
> the code is made to build external kernel modules for 3.18. The patches
> sent in this series are meant for 3.19 and 3.20 kernels, and while they
> are based on the exact same sources, the patches differ in the following
> minor details:
>
>  * Code is moved to appropriate locations, such as ipc/kdbus,
>    include/uapi, tools/testing/selftests/kdbus/, Documentation/ etc.
>
>  * Include file location amendments, "kdbus.h" vs. <uapi/linux/kdbus.h>
>
>  * Added iov_iter_kvec() usage, as that's a new API in v3.19
>
>  * The file system magic number is moved to include/uapi/linux/magic.h
>
>  * d_materialise_unique() is renamed to d_splice_alias() to catch up
>    with changes in 3.19
>
>
> The commit this patch set is based on is tagged as "lkml-v3" in the
> upstream repository now.

OK, thanks for the explanation.

I wonder if it would be possible to have branches for each kernel
version in the code.google.com repo?  I build kdbus against a number
of kernels and trying to chase down different repos and patch sets to
match might get to be a chore.  I mean, I'm all for doing closet
development to get stuff ready for upstream but it's hard for others
to keep up when the closet keeps moving :)

josh
