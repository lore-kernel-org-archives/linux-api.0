From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v5 2/6] x86/arch_prctl/64 Rename do_arch_prctl to do_arch_prctl_64
Date: Thu, 22 Sep 2016 15:17:41 -0700
Message-ID: <CALCETrWtAgcUpvGkk=-xPD4of9mjMZKCm-BtzA-YU9iFCCuRjw@mail.gmail.com>
References: <20160921185824.18980-1-khuey@kylehuey.com> <20160921185824.18980-3-khuey@kylehuey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160921185824.18980-3-khuey-OhBmq/TcCDJWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kyle Huey <me-OhBmq/TcCDJWk0Htik3J/w@public.gmane.org>
Cc: Robert O'Callahan <robert-7ok7fSEJICeEi8DpZVb4nw@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Dmitry Safonov <dsafonov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Rafael J . Wysocki" <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Srinivas Pandruvada <srinivas.pandruvada-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, user
List-Id: linux-api@vger.kernel.org

On Wed, Sep 21, 2016 at 11:58 AM, Kyle Huey <me-OhBmq/TcCDJWk0Htik3J/w@public.gmane.org> wrote:
> In order to introduce new arch_prctls that are not 64 bit only, rename the
> existing 64 bit implementation to do_arch_prctl_64. Also rename the second
> argument to arch_prctl, which will no longer always be an address.

Reviewed-by: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
