From: Jessica Yu <jeyu@redhat.com>
Subject: Re: livepatch: old_name.number scheme in livepatch sysfs directory
Date: Mon, 2 Nov 2015 14:15:11 -0500
Message-ID: <20151102191511.GC24801@packer-debian-8-amd64.digitalocean.com>
References: <1446487137-8469-1-git-send-email-chris.j.arges@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1446487137-8469-1-git-send-email-chris.j.arges@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chris J Arges <chris.j.arges@canonical.com>
Cc: live-patching@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

+++ Chris J Arges [02/11/15 11:58 -0600]:
>The following directory structure will allow for cases when the same
>function name exists in a single object.
>	/sys/kernel/livepatch/<patch>/<object>/<function.number>
>
>The number is incremented on each known initialized func kobj thus creating
>unique names in this case.
>
>An example of this issue is documented here:
>	https://github.com/dynup/kpatch/issues/493
>
>Signed-off-by: Chris J Arges <chris.j.arges@canonical.com>

Thanks Chris. Verified that the patch fixes the panic caused by
multiple functions with the same name and object.

Acked-by: Jessica Yu <jeyu@redhat.com>
