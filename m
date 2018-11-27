From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: pkeys: Reserve PKEY_DISABLE_READ
Date: Tue, 27 Nov 2018 07:31:38 -0800
Message-ID: <58e263a6-9a93-46d6-c5f9-59973064d55e@intel.com>
References: <877ehnbwqy.fsf@oldenburg.str.redhat.com>
 <2d62c9e2-375b-2791-32ce-fdaa7e7664fd@intel.com>
 <87bm6zaa04.fsf@oldenburg.str.redhat.com>
 <6f9c65fb-ea7e-8217-a4cc-f93e766ed9bb@intel.com>
 <87k1ln8o7u.fsf@oldenburg.str.redhat.com>
 <20181108201231.GE5481@ram.oc3035372033.ibm.com>
 <87bm6z71yw.fsf@oldenburg.str.redhat.com>
 <20181109180947.GF5481@ram.oc3035372033.ibm.com>
 <87efbqqze4.fsf@oldenburg.str.redhat.com>
 <20181127102350.GA5795@ram.oc3035372033.ibm.com>
 <87zhtuhgx0.fsf@oldenburg.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <87zhtuhgx0.fsf@oldenburg.str.redhat.com>
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
To: Florian Weimer <fweimer@redhat.com>, Ram Pai <linuxram@us.ibm.com>
Cc: linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 11/27/18 3:57 AM, Florian Weimer wrote:
> I would have expected something that translates PKEY_DISABLE_WRITE |
> PKEY_DISABLE_READ into PKEY_DISABLE_ACCESS, and also accepts
> PKEY_DISABLE_ACCESS | PKEY_DISABLE_READ, for consistency with POWER.
> 
> (My understanding is that PKEY_DISABLE_ACCESS does not disable all
> access, but produces execute-only memory.)

Correct, it disables all data access, but not execution.
