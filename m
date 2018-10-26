From: Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH] seccomp: Add pkru into seccomp_data
Date: Fri, 26 Oct 2018 06:52:22 +0100
Message-ID: <20181026055222.GB5228@ram.oc3035372033.ibm.com>
References: <20181024153523.10974-1-msammler@mpi-sws.org>
 <87zhv3nrr0.fsf@oldenburg.str.redhat.com>
 <11a706bd-060f-41de-118b-bababfd83b3d@mpi-sws.org>
 <875zxqo0ee.fsf@oldenburg.str.redhat.com>
Reply-To: Ram Pai <linuxram@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <875zxqo0ee.fsf@oldenburg.str.redhat.com>
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
Cc: Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Michael Sammler <msammler@mpi-sws.org>, linuxppc-dev@lists.ozlabs.org
List-Id: linux-api@vger.kernel.org

On Thu, Oct 25, 2018 at 11:12:25AM +0200, Florian Weimer wrote:
> * Michael Sammler:
> 
> > Thank you for the pointer about the POWER implementation. I am not
> > familiar with POWER in general and its protection key feature at
> > all. Would the AMR register be the correct register to expose here?
> 
> Yes, according to my notes, the register is called AMR (special purpose
> register 13).

Yes. it is AMR register.

RP
