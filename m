From: Adhemerval Zanella <adhemerval.zanella@linaro.org>
Subject: Re: d_off field in struct dirent and 32-on-64 emulation
Date: Fri, 28 Dec 2018 09:53:21 -0200
Message-ID: <ae0530c9-5c46-5560-9734-1eacaf173b8d@linaro.org>
References: <87bm56vqg4.fsf@mid.deneb.enyo.de>
 <957967d7-5717-8ada-fb30-dfdf19898b6b@linaro.org>
 <87pntmu9iw.fsf@mid.deneb.enyo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87pntmu9iw.fsf@mid.deneb.enyo.de>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fw@deneb.enyo.de>
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, v9fs-developer@lists.sourceforge.net, libc-alpha@sourceware.org, qemu-devel@nongnu.org, ericvh@gmail.com, rminnich@sandia.gov, lucho@ionkov.net, hpa@zytor.com, arnd@arndb.de
List-Id: linux-api@vger.kernel.org



On 27/12/2018 16:09, Florian Weimer wrote:
> * Adhemerval Zanella:
> 
>> Also for glibc standpoint, although reverting it back to use getdents 
>> syscall for non-LFS mode might fix this issue for architectures that
>> provides non-LFS getdents syscall it won't be a fix for architectures 
>> that still provides off_t different than off64_t *and* only provides 
>> getdents64 syscall.
>>
>> Currently we only have nios2 and csky (unfortunately).  But since generic 
>> definition for off_t and off64_t still assumes non-LFS support, all new
>> 32-bits ports potentially might carry the issue.
> 
> For csky, we could still change the type of the non-standard d_off
> field to long long int.  This way, only telldir would have to fail
> when truncation is necessary, as mentioned below:

I think it makes no sense to continue making non-LFS as default for
newer 32 bits ports, the support will be emulated with LFS syscalls.
