From: Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH] pkeys: Introduce PKEY_ALLOC_SIGNALINHERIT and change
 signal semantics
Date: Wed, 2 May 2018 16:38:48 -0700
Message-ID: <20180502233848.GB5863@ram.oc3035372033.ibm.com>
References: <20180502132751.05B9F401F3041@oldenburg.str.redhat.com>
 <248faadb-e484-806f-1485-c34a72a9ca0b@intel.com>
 <822a28c9-5405-68c2-11bf-0c282887466d@redhat.com>
 <20180502211254.GA5863@ram.oc3035372033.ibm.com>
 <CALCETrUfO=vXg5rT-n=y8pLktcq5+ORvgpsOXCHG4GaugB3k2A@mail.gmail.com>
Reply-To: Ram Pai <linuxram@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
Content-Disposition: inline
In-Reply-To: <CALCETrUfO=vXg5rT-n=y8pLktcq5+ORvgpsOXCHG4GaugB3k2A@mail.gmail.com>
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
To: Andy Lutomirski <luto@amacapital.net>
Cc: Florian Weimer <fweimer@redhat.com>, linux-arch <linux-arch@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.org>, Dave Hansen <dave.hansen@intel.com>, linux-x86_64@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
List-Id: linux-api@vger.kernel.org

On Wed, May 02, 2018 at 09:18:11PM +0000, Andy Lutomirski wrote:
> On Wed, May 2, 2018 at 2:13 PM Ram Pai <linuxram@us.ibm.com> wrote:
> 
> 
> > > Ram, would you please comment?
> 
> > on POWER the pkey behavior will remain the same at entry or at exit from
> > the signal handler.  For eg:  if a key is read-disabled on entry into
> > the signal handler, and gets read-enabled in the signal handler, than it
> > will continue to be read-enabled on return from the signal handler.
> 
> > In other words, changes to key permissions persist across signal
> > boundaries.
> 
> I don't know about POWER's ISA, but this is crappy behavior.  If a thread
> temporarily grants itself access to a restrictive memory key and then gets
> a signal, the signal handler should *not* have access to that key.

This is a new requirement that I was not aware off. Its not documented
anywhere AFAICT.  Regardless of how the ISA behaves, its still a kernel
behavior that needs to be clearly defined.

-- 
Ram Pai
