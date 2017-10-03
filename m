From: Laura Abbott <labbott@redhat.com>
Subject: Re: [PATCH v5 2/2] staging: ion: create one device entry per heap
Date: Tue, 3 Oct 2017 14:42:32 -0700
Message-ID: <2417c969-357f-d5d9-153a-2180d09b0dc6@redhat.com>
References: <1506518409-16887-1-git-send-email-benjamin.gaignard@linaro.org>
 <1506518409-16887-3-git-send-email-benjamin.gaignard@linaro.org>
 <2e15edc2-a17f-3930-7d5b-4b5b7d2e0a4d@redhat.com>
 <20171003164849.rcdgez6lbpmq5llt@sirena.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171003164849.rcdgez6lbpmq5llt@sirena.org.uk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Brown <broonie@kernel.org>
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>, sumit.semwal@linaro.org, gregkh@linuxfoundation.org, arve@android.com, riandrews@android.com, dan.carpenter@oracle.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 10/03/2017 09:48 AM, Mark Brown wrote:
> On Mon, Oct 02, 2017 at 11:07:48AM -0700, Laura Abbott wrote:
> 
>> Thinking about this a bit more, I'm not 100% sure if this
>> will allow the security rules we want. Heap ids are assigned
>> dynamically and therefore so will the /dev/ionX designation.
>> From my understanding, security rules like selinux need to
>> be fully specified at boot time so I'm not sure how you would
>> be able to write rules to differentiate between /dev/ionX and
>> /dev/ionY without knowing the values at boottime.
> 
> Isn't this something that should be managable via udev rules that ensure
> stable names in the same way as for things like disks or ethernet
> controllers (even if it just ends up doing something like /dev/ion-gpu
> or whatever)?  If we're not giving it enough information to assign stable
> names where needed we probably need to fix that anyway.
> 

Android doesn't use a standard udev so we'd need something that
would work there. My understanding was that android needs everything
specified at boot unless that's changed.

There would be enough information to assign stable names
(e.g. /dev/ion-system) if we used the query ioctl to find out
what's actually available. Is just the ioctl useful though?

Thanks,
Laura
