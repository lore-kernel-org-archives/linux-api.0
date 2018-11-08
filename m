From: Ram Pai <linuxram@us.ibm.com>
Subject: Re: pkeys: Reserve PKEY_DISABLE_READ
Date: Thu, 8 Nov 2018 11:22:26 -0800
Message-ID: <20181108192226.GC5481@ram.oc3035372033.ibm.com>
References: <877ehnbwqy.fsf@oldenburg.str.redhat.com>
Reply-To: Ram Pai <linuxram@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <877ehnbwqy.fsf@oldenburg.str.redhat.com>
Content-Disposition: inline
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
To: Florian Weimer <fweimer@redhat.com>
Cc: linux-api@vger.kernel.org, dave.hansen@intel.com, linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org
List-Id: linux-api@vger.kernel.org

On Thu, Nov 08, 2018 at 01:05:09PM +0100, Florian Weimer wrote:
> Would it be possible to reserve a bit for PKEY_DISABLE_READ?
> 
> I think the POWER implementation can disable read access at the hardware
> level, but not write access, and that cannot be expressed with the
> current PKEY_DISABLE_ACCESS and PKEY_DISABLE_WRITE bits.

POWER hardware can disable-read and can **also disable-write**
at the hardware level. It can disable-execute aswell at the
hardware level.   For example if the key bits for a given key in the AMR
register is  
	0b01  it is read-disable
	0b10  it is write-disable

To support access-disable, we make the key value 0b11.

So in case if you want to know if the key is read-disable 'bitwise-and' it
against 0x1.  i.e  (x & 0x1)

RP
