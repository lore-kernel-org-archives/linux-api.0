From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: [RFC PATCH] seccomp: Add protection keys into seccomp_data
Date: Mon, 29 Oct 2018 10:29:18 -0700
Message-ID: <62e09400-0443-8db9-a389-ba4f4201226b@intel.com>
References: <20181029112343.27454-1-msammler@mpi-sws.org>
 <CAGXu5jJ2fFmEXfUzga3XBXcsHPuPWWf5zLeyn8+Z1oZVa8oTuQ@mail.gmail.com>
 <7d93080b-68bd-7563-bd3b-e7ee1545e367@intel.com>
 <CAG48ez1mY7Osdsc4iJ1JKq=C60wb9bQF=aHbi1fb=pb_V2XMJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <CAG48ez1mY7Osdsc4iJ1JKq=C60wb9bQF=aHbi1fb=pb_V2XMJA@mail.gmail.com>
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
To: Jann Horn <jannh@google.com>
Cc: wad@chromium.org, Kees Cook <keescook@chromium.org>, Linux API <linux-api@vger.kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, linuxram@us.ibm.com, Andy Lutomirski <luto@amacapital.net>, msammler@mpi-sws.org, linuxppc-dev@lists.ozlabs.org
List-Id: linux-api@vger.kernel.org

On 10/29/18 9:48 AM, Jann Horn wrote:
> On Mon, Oct 29, 2018 at 5:37 PM Dave Hansen <dave.hansen@intel.com> wrote:
>> I'm not sure this is a great use for PKRU.  I *think* the basic problem
>> is that you want to communicate some rights information down into a
>> filter, and you want to communicate it with PKRU.  While it's handy to
>> have an extra register that nobody (generally) mucks with, I'm not quite
>> convinced that we want to repurpose it this way.
> 
> That's not how I understand it; I believe that the context is probably
> https://arxiv.org/pdf/1801.06822.pdf ?
> My understanding is that PKRU is used for lightweight in-process
> sandboxing, and to extend this sandbox protection to the syscall
> interface, it is necessary to expose PKRU state to seccomp filters.
> In other words, this isn't using PKRU exclusively for passing rights
> into a filter, but it has to use PKRU anyway.

PKRU gives information about rights to various bits of application data.
 From that, a seccomp filter can infer the context, and thus the ability
for the code to call a given syscall at a certain point in time.

This makes PKRU an opt-in part of the syscall ABI, which is pretty
interesting.  We _could_ do the same kind of thing with any callee-saved
general purpose register, but PKRU is particularly attractive because
there is only one instruction that writes to it (well, outside of
XSAVE*), and random library code is very unlikely at this point to be
using it.

PKRU getting reset on signals, and the requirement now that it *can't*
be changed if you make syscalls probably needs to get thought about very
carefully before we do this, though.
