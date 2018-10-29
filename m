From: Michael Sammler <msammler@mpi-sws.org>
Subject: Re: [RFC PATCH] seccomp: Add protection keys into seccomp_data
Date: Mon, 29 Oct 2018 18:02:08 +0100
Message-ID: <24afa443-92e8-8202-845a-c1e1df1a3226@mpi-sws.org>
References: <20181029112343.27454-1-msammler@mpi-sws.org>
 <CAGXu5jJ2fFmEXfUzga3XBXcsHPuPWWf5zLeyn8+Z1oZVa8oTuQ@mail.gmail.com>
 <7d93080b-68bd-7563-bd3b-e7ee1545e367@intel.com>
 <CAG48ez1mY7Osdsc4iJ1JKq=C60wb9bQF=aHbi1fb=pb_V2XMJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <CAG48ez1mY7Osdsc4iJ1JKq=C60wb9bQF=aHbi1fb=pb_V2XMJA@mail.gmail.com>
Content-Language: en-GB
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
To: Jann Horn <jannh@google.com>, Dave Hansen <dave.hansen@intel.com>
Cc: wad@chromium.org, Kees Cook <keescook@chromium.org>, Linux API <linux-api@vger.kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, linuxram@us.ibm.com, Andy Lutomirski <luto@amacapital.net>, linuxppc-dev@lists.ozlabs.org
List-Id: linux-api@vger.kernel.org

On 10/29/2018 05:48 PM, Jann Horn wrote:
> On Mon, Oct 29, 2018 at 5:37 PM Dave Hansen <dave.hansen@intel.com> wrote:
>> On 10/29/18 9:25 AM, Kees Cook wrote:
>>> On Mon, Oct 29, 2018 at 4:23 AM, Michael Sammler <msammler@mpi-sws.org> wrote:
>>>> Add the current value of an architecture specific protection keys
>>>> register (currently PKRU on x86) to data available for seccomp-bpf
>>>> programs to work on. This allows filters based on the currently
>>>> enabled protection keys.
>> How does the current "assignment" of protection keys to the various uses
>> get communicated to the filter?
> I assume that you first allocate your protection keys, then install the filter?
>
Yes, but I agree that it should probably be documented, that the filter 
should only look at the parts of the PKRU, which belong to pkeys the 
user space program allocated (if the kernel wants to use some parts of 
the PKRU for its own purposes).
>> I'm not sure this is a great use for PKRU.  I *think* the basic problem
>> is that you want to communicate some rights information down into a
>> filter, and you want to communicate it with PKRU.  While it's handy to
>> have an extra register that nobody (generally) mucks with, I'm not quite
>> convinced that we want to repurpose it this way.
> That's not how I understand it; I believe that the context is probably
> https://arxiv.org/pdf/1801.06822.pdf ?
> My understanding is that PKRU is used for lightweight in-process
> sandboxing, and to extend this sandbox protection to the syscall
> interface, it is necessary to expose PKRU state to seccomp filters.
> In other words, this isn't using PKRU exclusively for passing rights
> into a filter, but it has to use PKRU anyway.
Yes, https://arxiv.org/pdf/1801.06822.pdf is indeed the context and what 
you say is correct.
>> Also, I'm not sure the kernel provides the PKRU guarantees you want at
>> the moment.  Our implementation *probably* works, but it's mostly by
>> accident.
I don't know, which guarantees about the PKRU are provided at the 
moment, but the only guarantee needed for this patch is, that the kernel 
does not change the bits of the PKRU register, which belong to pkeys 
allocated by the user program, between the syscall entry and the call to 
secure_computing(). Is there are use case where the kernel would like to 
modify these bits of the PKRU?

-- MIchael
