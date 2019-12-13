From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v7 1/1] ns: add binfmt_misc to the user namespace
Date: Fri, 13 Dec 2019 14:59:37 -0500
Message-ID: <1576267177.4060.4.camel@HansenPartnership.com>
References: <20191107140304.8426-1-laurent@vivier.eu>
         <20191107140304.8426-2-laurent@vivier.eu>
         <7cb245ed-f738-7991-a09b-b27152274b9f@vivier.eu>
         <20191213185110.06b52cf4@md1za8fc.ad001.siemens.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191213185110.06b52cf4@md1za8fc.ad001.siemens.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Henning Schild <henning.schild@siemens.com>, Laurent Vivier <laurent@vivier.eu>
Cc: linux-kernel@vger.kernel.org, Dmitry Safonov <dima@arista.com>, linux-fsdevel@vger.kernel.org, Eric Biederman <ebiederm@xmission.com>, linux-api@vger.kernel.org, Andrei Vagin <avagin@gmail.com>, =?ISO-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>, Greg Kurz <groug@kaod.org>, Jann Horn <jannh@google.com>, containers@lists.linux-foundation.org, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kiszka <jan.kiszka@siemens.com>
List-Id: linux-api@vger.kernel.org

On Fri, 2019-12-13 at 18:51 +0100, Henning Schild wrote:
> Hi all,
> 
> that is a very useful contribution, which will hopefully be
> considered.

I'm technically the maintainer on the you touched it last you own it
basis, so if Christian's concerns get addressed I'll shepherd it
upstream.

James
