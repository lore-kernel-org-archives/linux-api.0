From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] seccomp: Add pkru into seccomp_data
Date: Fri, 26 Oct 2018 01:35:39 +0100
Message-ID: <CAGXu5jLE2VBqo_rkBJ+BJkp1==WLLg=N=-3gjTCCjcN1=bodSg@mail.gmail.com>
References: <20181024153523.10974-1-msammler@mpi-sws.org>
 <87zhv3nrr0.fsf@oldenburg.str.redhat.com>
 <11a706bd-060f-41de-118b-bababfd83b3d@mpi-sws.org>
 <875zxqo0ee.fsf@oldenburg.str.redhat.com>
 <c4d3f5c1-a2dc-5b44-4d12-1fae829a372c@mpi-sws.org>
 <CALCETrX_E5_p1-MjCcdtRQbziCCzXcOCfxRBckZx_zbO1QX=Dw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <CALCETrX_E5_p1-MjCcdtRQbziCCzXcOCfxRBckZx_zbO1QX=Dw@mail.gmail.com>
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
Cc: Florian Weimer <fweimer@redhat.com>, Will Drewry <wad@chromium.org>, Linux API <linux-api@vger.kernel.org>, linuxram@us.ibm.com, Michael Sammler <msammler@mpi-sws.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 26, 2018 at 12:00 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> You could bite the bullet and add seccomp eBPF support :)

I'm not convinced this is a good enough reason for gaining the eBPF
attack surface yet.

-Kees

-- 
Kees Cook
