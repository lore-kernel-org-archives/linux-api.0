From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: [RFC PATCH] seccomp: Add protection keys into seccomp_data
Date: Mon, 29 Oct 2018 15:33:54 -0700
Message-ID: <6c7cd491-ab12-b553-68cf-f66b2eaa25de@intel.com>
References: <20181029112343.27454-1-msammler@mpi-sws.org>
 <CAGXu5jJ2fFmEXfUzga3XBXcsHPuPWWf5zLeyn8+Z1oZVa8oTuQ@mail.gmail.com>
 <7d93080b-68bd-7563-bd3b-e7ee1545e367@intel.com>
 <CAG48ez1mY7Osdsc4iJ1JKq=C60wb9bQF=aHbi1fb=pb_V2XMJA@mail.gmail.com>
 <62e09400-0443-8db9-a389-ba4f4201226b@intel.com>
 <2fefcbfc-1d7e-dfe8-d49a-07824218d389@mpi-sws.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <2fefcbfc-1d7e-dfe8-d49a-07824218d389@mpi-sws.org>
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
Cc: wad@chromium.org, Kees Cook <keescook@chromium.org>, Linux API <linux-api@vger.kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, linuxram@us.ibm.com, Andy Lutomirski <luto@amacapital.net>, linuxppc-dev@lists.ozlabs.org
List-Id: linux-api@vger.kernel.org

On 10/29/18 2:55 PM, Michael Sammler wrote:
>> PKRU getting reset on signals, and the requirement now that it *can't*
>> be changed if you make syscalls probably needs to get thought about very
>> carefully before we do this, though.
> I am not sure, whether I follow you. Are you saying, that PKRU is
> currently not guaranteed to be preserved across system calls?
> This would make it very hard to use protection keys if libc does not
> save and restore the PKRU before/after systemcalls (and I am not aware
> of this).

It's preserved *across* system calls, but you have to be a bit careful
using it _inside_ the kernel.  We could context switch off to something
else, and not think that we need to restore PKRU until _just_ before we
return to userspace.

> Or do you mean, that the kernel might want to use the PKRU register for
> its own purposes while it is executing?

That, or we might keep another process's PKRU state in the register if
we don't think anyone is using it.  Now that I think about it, I think
Rik (cc'd, who was working on those patches) *had* to explicitly restore
PKRU because it's hard to tell where we might do a copy_to/from_user()
and need it.

> Then the solution you proposed in another email in this thread would
> work: instead of providing the seccomp filter with the current value of
> the PKRU (which might be different from what the user space expects) use
> the user space value which must have been saved somewhere (otherwise it
> would not be possible to restore it).

Yep, that's the worst-case scenario: either fetch PKRU out of the XSAVE
buffer (current->fpu->something), or just restore them using an existing
API before doing RDPKRU.

But, that's really an implementation detail.  The effect on the ABI and
how this might constrain future pkeys use is my bigger worry.

I'd also want to make sure that your specific use-case is compatible
with all the oddities of pkeys, like the 'clone' and signal behavior.
Some of that is spelled out here:

	http://man7.org/linux/man-pages/man7/pkeys.7.html

One thing that's a worry is that we have never said that you *can't*
write to arbitrary permissions in PKRU.  I can totally see some really
paranoid code saying, "I'm about to do something risky, so I'll turn off
access to *all* pkeys", or " turn off all access except my current
stack".  If they did that, they might also inadvertently disable access
to certain seccomp-restricted syscalls.

We can fix that up by documenting restrictions like "code should never
change the access rights of any pkey other than those that it
allocated", but that doesn't help any old code (of which I hope there is
relatively little).
