From: Andre Przywara <andre.przywara-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 2/2] selftests/userfaultfd: improve syscall number
 definition
Date: Wed, 23 Sep 2015 14:11:33 +0100
Message-ID: <5602A505.8090804@arm.com>
References: <1442918756-17892-1-git-send-email-andre.przywara@arm.com>
 <1442918756-17892-3-git-send-email-andre.przywara@arm.com>
 <56015C59.5010300@osg.samsung.com> <20150922140625.GH25412@redhat.com>
 <56018CA0.8050600@arm.com> <1443002109.9279.1.camel@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443002109.9279.1.camel-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Cc: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Will Deacon <Will.Deacon-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Michael,

On 23/09/15 10:55, Michael Ellerman wrote:
> On Tue, 2015-09-22 at 18:15 +0100, Andre Przywara wrote:
>> On 22/09/15 15:06, Andrea Arcangeli wrote:
>>> Andre, could you see if linux-next (which includes -mm) works for you
>>> by just running "cd tools/testing/selftests/vm/ && make"? If there's
>>> any further change required could you diff it against linux-next?
>>
>> This doesn't compile now for me, because it looks into
>> /usr/include/asm/unistd.h, which I keep to the distribution copy of it.
>> Also linux/userfaultfd.h is missing, because it's brand new.
> ...
>> I guess the right solution would be to hack the Makefile to set the
>> include path to the kernel's copy of include/uapi, though I am not sure
>> this works cleanly for different architectures and separate build
>> directories. I will give this a try ...
> 
> Not that's not the right solution.
> 
> The right solution is to export the kernel headers, the Makefile will pick them
> up (at least in linux-next):

Actually that was I was hoping for, I just missed the possibility of
headers_install to put the files back into the kernel tree (I usually
use it with INSTALL_HDR_PATH for packaging).

> 
>   $ cd linux
>   $ make headers_install
>   $ ls usr/include/
>   asm/  asm-generic/  drm/  linux/  misc/  mtd/  rdma/  scsi/  sound/  uapi/  video/  xen/
>   $ make -C tools/testing/selftests TARGETS=vm
>   ...
>   $ ls tools/testing/selftests/vm/userfaultfd
>   tools/testing/selftests/vm/userfaultfd*

Yes, that works. Now I have just to figure out how to arrange this with
out-of-tree build directories.

Cheers,
Andre.
