From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: Re: [PATCH 01/20] drm: use __u{32,64} instead of uint{32,64}_t in
 virtgpu_drm.h
Date: Mon, 7 Dec 2015 15:45:57 +0200
Message-ID: <20151207134557.GR6104@lakka.kapsi.fi>
References: <1448892658-14256-1-git-send-email-gabriel@lse.epita.fr>
 <1448892658-14256-2-git-send-email-gabriel@lse.epita.fr>
 <CACvgo52bSiTJmze45WUSs+sW0RfcW7Uwaworb68YA54b3PvR9Q@mail.gmail.com>
 <CAPM=9tw1Un5-fZUzYGzXLhVikEHj9gw1FfBDc=YMD7xeeKxS9Q@mail.gmail.com>
 <CACvgo504nh0-KQUMEm7D2U8cSvkFeZFhgb6Pgxkmtb1PRG6jUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACvgo504nh0-KQUMEm7D2U8cSvkFeZFhgb6Pgxkmtb1PRG6jUw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Emil Velikov <emil.l.velikov@gmail.com>
Cc: Dave Airlie <airlied@gmail.com>, Gabriel Laskar <gabriel@lse.epita.fr>, David Airlie <airlied@linux.ie>, "open list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>, "open list:ABI/API" <linux-api@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Dec 07, 2015 at 01:29:41PM +0000, Emil Velikov wrote:
> On 5 December 2015 at 21:03, Dave Airlie <airlied@gmail.com> wrote:
> > On 5 December 2015 at 00:22, Emil Velikov <emil.l.velikov@gmail.com> wrote:
> >> On 30 November 2015 at 14:10, Gabriel Laskar <gabriel@lse.epita.fr> wrote:
> >>> Signed-off-by: Gabriel Laskar <gabriel@lse.epita.fr>
> >>> CC: Emil Velikov <emil.l.velikov@gmail.com>
> >>> CC: Mikko Rapeli <mikko.rapeli@iki.fi>
> >>>
> >>> ---
> >>>  include/uapi/drm/virtgpu_drm.h | 98 +++++++++++++++++++++---------------------
> >>>  1 file changed, 49 insertions(+), 49 deletions(-)
> >>>
> >> For the series
> >> Reviewed-by: Emil Velikov <emil.l.velikov@gmail.com>
> >>
> >> Dave would you have any comments wrt this and the remainder of Mikko's
> >> series ? Alternatively what can we do to get those merged (would you
> >> like a branch/pull request) ?
> >
> > Yeah a git pull for these would be good, it's about all I can do to
> > care about them.
> >
> >From your earlier reply I got the impression that you'll pick Mikko's
> work. Either way, glad to see some progress on the topic.
> 
> Mikko, Gabriel,
> 
> Will you guys be so kind to send pull requests or shall I ?

Go a head and send one. I guess you are talking about the drm specific
patches.

I tested Gabriel's changes too and found one more userspace compilation
problem from the now exported AMD header.

You can pick my patches from emails or latest draft is at
https://github.com/mcfrisk/linux/tree/headers_test_v05

I'm following Linus'es tree and dropping changes which get merged from my
development branch.

-Mikko
