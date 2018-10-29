From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v3 0/2] sysctl: handle overflow for file-max
Date: Mon, 29 Oct 2018 14:44:29 -0700
Message-ID: <CAGXu5jJwSRQ3dOgNW_X0Fk+8gT+ACiBZPJ79g-aCfqiWsm=ewg@mail.gmail.com>
References: <20181016223322.16844-1-christian@brauner.io> <20181029145818.4bqmy25itjnqhodg@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181029145818.4bqmy25itjnqhodg@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>, Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Joe Lawrence <joe.lawrence@redhat.com>, Waiman Long <longman@redhat.com>, Dominik Brodowski <linux@dominikbrodowski.net>, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 29, 2018 at 7:58 AM, Christian Brauner <christian@brauner.io> wrote:
> On Wed, Oct 17, 2018 at 12:33:20AM +0200, Christian Brauner wrote:
>> Hey,
>>
>> Here is v3 of this patchset. Changelogs are in the individual commits.
>>
>> Currently, when writing
>>
>> echo 18446744073709551616 > /proc/sys/fs/file-max
>>
>> /proc/sys/fs/file-max will overflow and be set to 0. That quickly
>> crashes the system.
>>
>> The first version of this patch intended to detect the overflow and cap
>> at ULONG_MAX. However, we should not do this and rather return EINVAL on
>> overflow. The reasons are:
>> - this aligns with other sysctl handlers that simply reject overflows
>>   (cf. [1], [2], and a bunch of others)
>> - we already do a partial fail on overflow right now
>>   Namely, when the TMPBUFLEN is exceeded. So we already reject values
>>   such as 184467440737095516160 (21 chars) but accept values such as
>>   18446744073709551616 (20 chars) but both are overflows. So we should
>>   just always reject 64bit overflows and not special-case this based on
>>   the number of chars.
>>
>> (This patchset is in reference to https://lkml.org/lkml/2018/10/11/585.)
>
> Just so that we don't forget, can we make sure that this gets picked
> into linux-next? :)

I was hoping akpm would take this? Andrew, does the v3 look okay to you?

-Kees

-- 
Kees Cook
