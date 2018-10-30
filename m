From: Michael Sammler <msammler@mpi-sws.org>
Subject: Re: [RFC PATCH] seccomp: Add protection keys into seccomp_data
Date: Tue, 30 Oct 2018 11:55:17 +0100
Message-ID: <257eca22-8ef4-2621-8a62-d65d611abf61@mpi-sws.org>
References: <20181029112343.27454-1-msammler@mpi-sws.org>
 <CAGXu5jJ2fFmEXfUzga3XBXcsHPuPWWf5zLeyn8+Z1oZVa8oTuQ@mail.gmail.com>
 <7d93080b-68bd-7563-bd3b-e7ee1545e367@intel.com>
 <CAG48ez1mY7Osdsc4iJ1JKq=C60wb9bQF=aHbi1fb=pb_V2XMJA@mail.gmail.com>
 <62e09400-0443-8db9-a389-ba4f4201226b@intel.com>
 <2fefcbfc-1d7e-dfe8-d49a-07824218d389@mpi-sws.org>
 <6c7cd491-ab12-b553-68cf-f66b2eaa25de@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <6c7cd491-ab12-b553-68cf-f66b2eaa25de@intel.com>
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
To: Dave Hansen <dave.hansen@intel.com>, Jann Horn <jannh@google.com>
Cc: wad@chromium.org, Kees Cook <keescook@chromium.org>, Linux API <linux-api@vger.kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, linuxram@us.ibm.com, Andy Lutomirski <luto@amacapital.net>, linuxppc-dev@lists.ozlabs.org
List-Id: linux-api@vger.kernel.org

On 10/29/2018 11:33 PM, Dave Hansen wrote:
> But, that's really an implementation detail.  The effect on the ABI and
> how this might constrain future pkeys use is my bigger worry.
> 
> I'd also want to make sure that your specific use-case is compatible
> with all the oddities of pkeys, like the 'clone' and signal behavior.
> Some of that is spelled out here:
> 
> 	http://man7.org/linux/man-pages/man7/pkeys.7.html
> 

I think my specific use case is compatible with these oddities since the 
untrusted code is not allowed to install signal handlers or spawn 
threads himself but only through the trusted code, which ensures, that 
the PKRU has the correct value when control passes back to the untrusted 
code. But I agree that these oddities are something a programmer needs 
to take into account if he uses pkeys in general (and this patch adds 
new considerations to it if the program installs a seccomp filter and 
e.g. wants to do system calls from a signal handler).

> One thing that's a worry is that we have never said that you *can't*
> write to arbitrary permissions in PKRU.  I can totally see some really
> paranoid code saying, "I'm about to do something risky, so I'll turn off
> access to *all* pkeys", or " turn off all access except my current
> stack".  If they did that, they might also inadvertently disable access
> to certain seccomp-restricted syscalls.
> 
> We can fix that up by documenting restrictions like "code should never
> change the access rights of any pkey other than those that it
> allocated", but that doesn't help any old code (of which I hope there is
> relatively little).
> 

I can also see paranoid code wanting to do something like you describe 
and I think, that we should try to not forbid this behaviour. 
Documenting restrictions on code which writes to the PKRU as you 
describe would be one way to go, but this would disallow this paranoid 
use case if I understand it correctly because the code would not be 
allowed to disable access to all except of one pkey.

My idea would be to not put the blame on the code which writes to the 
PKRU but on the code which installs the seccomp filter based on the 
PKRU: It has to make sure, that it allows the system calls which the 
paranoid code should be allowed to do when the pkey of the paranoid code 
is the (only) enabled pkey. This could be ensured e.g. by the paranoid 
code providing the pkey it intends to use to the code which installs the 
seccomp filter. This of course means, that you need to know what you are 
doing, when you install a seccomp filter which depends on the PKRU, but 
I think this is already the case when you install a seccomp filter 
without this patch (but maybe someone with more seccomp experience than 
me can say better how much reasoning is needed to install a seccomp 
filter without and with this patch).

-- Michael
