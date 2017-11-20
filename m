From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Documentation patch for namespaced file capabilities
Date: Mon, 20 Nov 2017 10:36:11 +0100
Message-ID: <CAKgNAkiAeqbD=G6hnExh4cC84nA2mU6xdLzzS0F2x1wviEPgHg@mail.gmail.com>
Reply-To: mtk.manpages@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Amir Goldstein <amir73il@gmail.com>, Stefan Berger <stefanb@linux.vnet.ibm.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux Containers <containers@lists.linux-foundation.org>, lkp@01.org, xiaolong.ye@intel.com, linux-kernel <linux-kernel@vger.kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Tycho Andersen <tycho@docker.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, christian.brauner@mailbox.org, Vivek Goyal <vgoyal@redhat.com>, LSM List <linux-security-module@vger.kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

Hi Serge,

At the moment man-pages lacks documentation of the namespaced file
capability feature that you added with commit
8db6c34f1dbc8e06aa016a9b829b06902c3e1340. Would you be able to send a
patch describing the feature?

Presumably, the patch would be for the capabilities(7) page (or
perhaps for the user_namespaces(7) page, if that seems more
appropriate), As well as documenting the semantics, it would be good
to include an example or two of the notation that is used for the
xattr names.

Presumably also there will be some changes in userspace tools
(setcap/getcap?). Do you know anything about what's happening there?

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
