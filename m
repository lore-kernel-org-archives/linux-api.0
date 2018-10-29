From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: [RFC PATCH] seccomp: Add protection keys into seccomp_data
Date: Mon, 29 Oct 2018 10:07:09 -0700
Message-ID: <9534815a-6d58-9e21-6ea5-51b9900b16e2@intel.com>
References: <20181029112343.27454-1-msammler@mpi-sws.org>
 <CAGXu5jJ2fFmEXfUzga3XBXcsHPuPWWf5zLeyn8+Z1oZVa8oTuQ@mail.gmail.com>
 <7d93080b-68bd-7563-bd3b-e7ee1545e367@intel.com>
 <CAG48ez1mY7Osdsc4iJ1JKq=C60wb9bQF=aHbi1fb=pb_V2XMJA@mail.gmail.com>
 <24afa443-92e8-8202-845a-c1e1df1a3226@mpi-sws.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <24afa443-92e8-8202-845a-c1e1df1a3226@mpi-sws.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: Michael Sammler <msammler@mpi-sws.org>, Jann Horn <jannh@google.com>
Cc: wad@chromium.org, Kees Cook <keescook@chromium.org>, Rik van Riel <riel@surriel.com>, Linux API <linux-api@vger.kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, linuxram@us.ibm.com, Andy Lutomirski <luto@amacapital.net>, linuxppc-dev@lists.ozlabs.org
List-Id: linux-api@vger.kernel.org

On 10/29/18 10:02 AM, Michael Sammler wrote:
>>> Also, I'm not sure the kernel provides the PKRU guarantees you want at
>>> the moment.  Our implementation *probably* works, but it's mostly by
>>> accident.
> I don't know, which guarantees about the PKRU are provided at the
> moment, but the only guarantee needed for this patch is, that the kernel
> does not change the bits of the PKRU register, which belong to pkeys
> allocated by the user program, between the syscall entry and the call to
> secure_computing(). Is there are use case where the kernel would like to
> modify these bits of the PKRU?

We've been talking about doing more lax save/restore of the XSAVE
content (PKRU is part of this content).  We would, for instance, only
restore it when returning to userspace, but PKRU might not be up-to-date
with the value in current->fpu.

It's not a deal-breaker with your approach, it's just something to be
careful of and make sure PKRU is up-to-date before you go use it.
