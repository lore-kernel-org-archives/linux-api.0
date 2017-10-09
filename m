From: Laura Abbott <labbott@redhat.com>
Subject: Re: [PATCH v5 2/2] staging: ion: create one device entry per heap
Date: Mon, 9 Oct 2017 14:25:47 -0700
Message-ID: <e3f91eff-df33-e203-2ce2-1f1dc98236ef@redhat.com>
References: <1506518409-16887-1-git-send-email-benjamin.gaignard@linaro.org>
 <1506518409-16887-3-git-send-email-benjamin.gaignard@linaro.org>
 <2e15edc2-a17f-3930-7d5b-4b5b7d2e0a4d@redhat.com>
 <20171003164849.rcdgez6lbpmq5llt@sirena.org.uk>
 <2417c969-357f-d5d9-153a-2180d09b0dc6@redhat.com>
 <20171003230830.GA132839@sspatil-desktop.mtv.corp.google.com>
 <20171004101720.ob5f467tro7agpcz@sirena.co.uk>
 <CA+M3ks5ZCUdTU5qU=Xi-MXXJQS6X-x=7qqs-5Myi7zeAAi8mJg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+M3ks5ZCUdTU5qU=Xi-MXXJQS6X-x=7qqs-5Myi7zeAAi8mJg@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>, Mark Brown <broonie@kernel.org>
Cc: Sandeep Patil <sspatil@google.com>, driverdevel <devel@driverdev.osuosl.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, =?UTF-8?Q?Arve_Hj=c3=b8nnev=c3=a5g?= <arve@android.com>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Riley Andrews <riandrews@android.com>, linux-api@vger.kernel.org, Sumit Semwal <sumit.semwal@linaro.org>, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: linux-api@vger.kernel.org

On 10/05/2017 06:06 AM, Benjamin Gaignard wrote:
> 2017-10-04 12:17 GMT+02:00 Mark Brown <broonie@kernel.org>:
>> On Tue, Oct 03, 2017 at 04:08:30PM -0700, Sandeep Patil wrote:
>>
>>> It is entirely possible and easy in android/ueventd to create those nodes
>>> under "/dev/ion/".  (assuming the heap 'subsystem' for these new devices will
>>> point to 'ion').
> 
> I think it is the same problem than for webcam under v4l framework.
> Each time you plug a webcam you got a v4l node but android/uevent rules
> the plug order doesn't have impact.
> The same think will happen for ion nodes it may be even easier because
> the heap will always being created in the smae order for a given product
> configuration.
> 

Relying on the heap being created in the same order seems troublesome.
If for some reason it changes in the kernel we might break something
in userspace.

Anyway, to move this forward I think we need to see a proof of concept
of using selinux to protect access to specific heaps.

Thanks,
Laura

>>
>> The reason I didn't say /dev/ion/foo initially is that if people want to
>> keep the existing /dev/ion around for compatibility reasons then the
>> /dev/ion name isn't available which might cause issues.  Otherwise just
>> dumping everything under a directory (perhaps with a different name) was
>> my first thought as well.
>>
>>> (Also FWIW, the SELinux permissions are also possible with the current ion
>>> implementation by adding rules to disallow specific ioctls instead of adding
>>> permissions to access device node as this change would do)
>>
>> AIUI the request is to limit access to specific heaps, and obviously not
>> everyone wants to deal with SELinux at all.
