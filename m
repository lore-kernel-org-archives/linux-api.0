From: Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Provision for filesystem specific open flags
Date: Mon, 20 Nov 2017 15:03:07 +0100
Message-ID: <9a5629c2-611c-5025-2228-847377414591@redhat.com>
References: <BN3PR0801MB2257E7D90F26A85C1D16730EAB540@BN3PR0801MB2257.namprd08.prod.outlook.com>
 <20171110172344.GA15288@lst.de>
 <BN3PR0801MB2257E71C2A12EA41C77FF7EBAB540@BN3PR0801MB2257.namprd08.prod.outlook.com>
 <20171110192902.GA10339@bombadil.infradead.org>
 <BN3PR0801MB22576444104088CEDD24DE7DAB540@BN3PR0801MB2257.namprd08.prod.outlook.com>
 <15b7fb2c-0ab7-014c-025f-b95d254e75d0@fastmail.fm>
 <BN3PR0801MB2257378E7F3596E0E61C1F89AB2B0@BN3PR0801MB2257.namprd08.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BN3PR0801MB2257378E7F3596E0E61C1F89AB2B0-1I06WyKSH1RpbkYrVjfdjVJr2SjL+wq6nBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Fu, Rodney" <rfu-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>, Bernd Schubert <bernd.schubert-97jfqw80gc6171pxa8y+qA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org" <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 11/13/2017 09:19 PM, Fu, Rodney wrote:
> Yes, an ioctl open is possible but not ideal.  The interface would require an
> additional open to perform the ioctl against.  The open system call is really a
> great place to pass control information to the filesystem and any other solution
> seems less elegant.

But with the FS-specific open flag, you would have to do an open call 
with O_PATH, check that the file system is what you expect, and then 
openat the O_PATH descriptor to get a full descriptor.  If you don't 
follow this protocol, you might end up using a custom open flag with a 
different file system which has completely different semantics for the flag.

So ioctl actually is much simpler here and needs fewer system calls.

(Due to per-file bind mounts, there is no way to figure out the file 
system on which a file is located without actually opening the file.)

Thanks,
Florian
