From: Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [PATCH v2 2/3] tools: sync linux/bpf.h
Date: Thu, 25 Oct 2018 17:07:22 +0200
Message-ID: <CACAyw9-GhNqvh5ewPrE3bGfXrzSVMsaOCneLPESVvkrsC79qLg@mail.gmail.com>
References: <20181001104509.24211-1-lmb@cloudflare.com> <20181008103221.13468-1-lmb@cloudflare.com>
 <20181008103221.13468-3-lmb@cloudflare.com> <CAPhsuW5fbhQ1SBurL2q6hm=yV0a_Vw-_gjsz8LHJ76QwcqVXsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CAPhsuW5fbhQ1SBurL2q6hm=yV0a_Vw-_gjsz8LHJ76QwcqVXsQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: liu.song.a23@gmail.com
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, 9 Oct 2018 at 01:12, Song Liu <liu.song.a23@gmail.com> wrote:
>
> On Mon, Oct 8, 2018 at 3:34 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> >
> > Synchronize changes to linux/bpf.h from
> > commit 88db241b34bf ("bpf: allow zero-initializing hash map seed").
> I guess we cannot keep this hash during git-am? We probably don't
> need this hash anyway, as the two patches will be applied back to back.

I copied what was done in one of the previous commits that synced the
header. I'm a bit at a
loss what to put in the commit message otherwise.

-- 
Lorenz Bauer  |  Systems Engineer
25 Lavington St., London SE1 0NZ

www.cloudflare.com
