From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] ipc: Fix building compat mode without sysvipc
Date: Wed, 6 Mar 2019 16:00:39 +0100
Message-ID: <CAK8P3a1nZU984gSsbw2pg2a4nPSfc687BusJXwQHvs8U8LXvdw@mail.gmail.com>
References: <20190306142944.834167-1-arnd@arndb.de> <3614a6b8-0c2f-747c-ce60-b58e79c5cec5@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3614a6b8-0c2f-747c-ce60-b58e79c5cec5@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Laura Abbott <labbott@redhat.com>
Cc: y2038 Mailman List <y2038@lists.linaro.org>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Dominik Brodowski <linux@dominikbrodowski.net>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 6, 2019 at 3:44 PM Laura Abbott <labbott@redhat.com> wrote:
>
> On 3/6/19 6:29 AM, Arnd Bergmann wrote:
> > As John Stultz noticed, my y2038 syscall series caused a link
> > failure when CONFIG_SYSVIPC is enabled but CONFIG_COMPAT is
> > enabled:
> >
>
> is this supposed to be "CONFIG_SYSVIPC is disabled" to match the
> subject?

Fixing it now, thanks!

      Arnd
