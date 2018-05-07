From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH] pkeys: Introduce PKEY_ALLOC_SIGNALINHERIT and change
 signal semantics
Date: Mon, 7 May 2018 11:47:17 +0200
Message-ID: <0bd6584e-f520-9e2d-8adb-f79d3d7e9340@redhat.com>
References: <20180502132751.05B9F401F3041@oldenburg.str.redhat.com>
 <248faadb-e484-806f-1485-c34a72a9ca0b@intel.com>
 <822a28c9-5405-68c2-11bf-0c282887466d@redhat.com>
 <20180502211254.GA5863@ram.oc3035372033.ibm.com>
 <CALCETrUfO=vXg5rT-n=y8pLktcq5+ORvgpsOXCHG4GaugB3k2A@mail.gmail.com>
 <20180502233848.GB5863@ram.oc3035372033.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <20180502233848.GB5863@ram.oc3035372033.ibm.com>
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
To: Ram Pai <linuxram@us.ibm.com>, Andy Lutomirski <luto@amacapital.net>
Cc: linux-arch <linux-arch@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.org>, Dave Hansen <dave.hansen@intel.com>, linux-x86_64@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
List-Id: linux-api@vger.kernel.org

On 05/03/2018 01:38 AM, Ram Pai wrote:
> This is a new requirement that I was not aware off. Its not documented
> anywhere AFAICT.

Correct.  All inheritance behavior was deliberately left unspecified.

I'm surprised about the reluctance to fix the x86 behavior.  Are there 
any applications at all for the current semantics?

I guess I can implement this particular glibc hardening on POWER only 
for now.

Thanks,
Florian
