From: Florian Weimer <fw@deneb.enyo.de>
Subject: Re: d_off field in struct dirent and 32-on-64 emulation
Date: Fri, 28 Dec 2018 08:38:17 +0100
Message-ID: <87bm56w17a.fsf@mid.deneb.enyo.de>
References: <87bm56vqg4.fsf@mid.deneb.enyo.de>
        <20181228022338.GA27992@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181228022338.GA27992@altlinux.org> (Dmitry V. Levin's message
        of "Fri, 28 Dec 2018 05:23:39 +0300")
Sender: linux-kernel-owner@vger.kernel.org
To: "Dmitry V. Levin" <ldv@altlinux.org>
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, v9fs-developer@lists.sourceforge.net, libc-alpha@sourceware.org, qemu-devel@nongnu.org, ericvh@gmail.com, rminnich@sandia.gov, lucho@ionkov.net, hpa@zytor.com, arnd@arndb.de
List-Id: linux-api@vger.kernel.org

* Dmitry V. Levin:

> On Thu, Dec 27, 2018 at 06:18:19PM +0100, Florian Weimer wrote:
>> We have a bit of an interesting problem with respect to the d_off
>> field in struct dirent.
>> 
>> When running a 64-bit kernel on certain file systems, notably ext4,
>> this field uses the full 63 bits even for small directories (strace -v
>> output, wrapped here for readability):
>> 
>> getdents(3, [
>>   {d_ino=1494304, d_off=3901177228673045825, d_reclen=40,
>> d_name="authorized_keys", d_type=DT_REG},
>>   {d_ino=1494277, d_off=7491915799041650922, d_reclen=24,
>> d_name=".", d_type=DT_DIR},
>>   {d_ino=1314655, d_off=9223372036854775807, d_reclen=24,
>> d_name="..", d_type=DT_DIR}
>> ], 32768) = 88
>> 
>> When running in 32-bit compat mode, this value is somehow truncated to
>> 31 bits, for both the getdents and the getdents64 (!) system call (at
>> least on i386).
>
> Why getdents64 system call is affected by this truncation,
> isn't it a kernel bug that has to be fixed in the kernel instead?

It's required because POSIX specifies that telldir and seekdir use
long int (and not off_t) as the seek offset.  If the kernel does not
truncate while keeping a useful value, these functions would turn
unusable.
