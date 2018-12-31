From: Joseph Myers <joseph@codesourcery.com>
Subject: Re: d_off field in struct dirent and 32-on-64 emulation
Date: Mon, 31 Dec 2018 17:03:40 +0000
Message-ID: <alpine.DEB.2.21.1812311657050.27287@digraph.polyomino.org.uk>
References: <87bm56vqg4.fsf@mid.deneb.enyo.de> <957967d7-5717-8ada-fb30-dfdf19898b6b@linaro.org> <87pntmu9iw.fsf@mid.deneb.enyo.de> <ae0530c9-5c46-5560-9734-1eacaf173b8d@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <libc-alpha-return-98897-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <ae0530c9-5c46-5560-9734-1eacaf173b8d@linaro.org>
To: Adhemerval Zanella <adhemerval.zanella@linaro.org>
Cc: Florian Weimer <fw@deneb.enyo.de>, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, v9fs-developer@lists.sourceforge.net, libc-alpha@sourceware.org, qemu-devel@nongnu.org, ericvh@gmail.com, rminnich@sandia.gov, lucho@ionkov.net, hpa@zytor.com, arnd@arndb.de
List-Id: linux-api@vger.kernel.org

On Fri, 28 Dec 2018, Adhemerval Zanella wrote:

> >> Currently we only have nios2 and csky (unfortunately).  But since generic 
> >> definition for off_t and off64_t still assumes non-LFS support, all new
> >> 32-bits ports potentially might carry the issue.
> > 
> > For csky, we could still change the type of the non-standard d_off
> > field to long long int.  This way, only telldir would have to fail
> > when truncation is necessary, as mentioned below:
> 
> I think it makes no sense to continue making non-LFS as default for
> newer 32 bits ports, the support will be emulated with LFS syscalls.

Any new 32-bit port that uses 64-bit time_t will also use 64-bit offsets 
(because we don't have any glibc configurations that support the 
combination of 64-bit time with 32-bit offsets, and don't want to add 
them).  That should apply for RISC-V 32-bit at least.

I've filed <https://sourceware.org/bugzilla/show_bug.cgi?id=24050> for 
missing overflow checks in telldir when the default off_t is wider than 
long int (currently just applies to x32; not sure why we don't see glibc 
test failures on x32 resulting from the quiet truncation, as the issue is 
certainly there in the source code).

-- 
Joseph S. Myers
joseph@codesourcery.com
