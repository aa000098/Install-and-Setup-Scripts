# age: set_num_threads.sh   
#        will set environment variables for number of threads to 10.

set_metep_gemm_env_nc_1_close() {


  #num_threads=36

  #export METEP_NUM_THREADS=${num_threads}
  #export OMP_NUM_THREADS=${num_threads}
  #export MKL_NUM_THREADS=${num_threads}
  #export MLAB_NUM_THREADS=${num_threads}
  #export TF_NUM_THREADS=${num_threads}
  #export OPENBLAS_NUM_THREADS=${num_threads}
  #export CUDA_VISIBLE_DEVICES=-1

  cpu_affinity="0-35:2, 1-35:2"

  export METEP_CPU_AFFINITY=${cpu_affinity}
  export GOMP_CPU_AFFINITY=${cpu_affinity}
  export GOMP_PROC_BIND=CLOSE
  export METEP_NUM_NODES=2
  export METEP_BIND=Close

  export METEP_GEMM_CPU_AFFINITY=${cpu_affinity}
  export METEP_NCT=1
  export METEP_NRT=3
  export METEP_NCT_BIND=Close

  #export METEP_FORCE_NCT=1
  #export METEP_ADJ_MC=1
  #export METEP_MC_NRT=0


  #echo "MMP_NUM_THREADS      = "$METEP_NUM_THREADS
  #echo "OMP_NUM_THREADS      = "$OMP_NUM_THREADS
  #echo "MKL_NUM_THREADS      = "$MKL_NUM_THREADS
  #echo "MLAB_NUM_THREADS     = "$MLAB_NUM_THREADS
  #echo "TF_NUM_THREADS       = "$TF_NUM_THREADS
  #echo "OPENBLAS_NUM_THREADS = "$OPENBLAS_NUM_THREADS

  echo "[Metep General]"
  echo "METEP_CPU_AFFINITY       = "$METEP_CPU_AFFINITY
  echo "GOMP_CPU_AFFINITY        = "$GOMP_CPU_AFFINITY
  echo "GOMP_PROC_BIND           = "$GOMP_PROC_BIND
  echo "METEP_NUM_NODES          = "$METEP_NUM_NODES
  echo "METEP_BIND               = "$METEP_BIND

  echo ""
  echo "[Metep Gemm]"
  echo "METEP_GEMM_CPU_AFFINITY  = "$METEP_GEMM_CPU_AFFINITY
  echo "METEP_NCT_BIND           = "$METEP_NCT_BIND
  echo "METEP_NCT                = "$METEP_NCT
  echo "METEP_NRT                = "$METEP_NRT

}

set_metep_gemm_env_nc_1_spread() {


  #num_threads=36

  #export METEP_NUM_THREADS=${num_threads}
  #export OMP_NUM_THREADS=${num_threads}
  #export MKL_NUM_THREADS=${num_threads}
  #export MLAB_NUM_THREADS=${num_threads}
  #export TF_NUM_THREADS=${num_threads}
  #export OPENBLAS_NUM_THREADS=${num_threads}
  #export CUDA_VISIBLE_DEVICES=-1

  cpu_affinity="0-35"

  export METEP_CPU_AFFINITY=${cpu_affinity}
  export GOMP_CPU_AFFINITY=${cpu_affinity}
  export METEP_NUM_NODES=2
  export METEP_BIND=Spread

  export METEP_GEMM_CPU_AFFINITY=${cpu_affinity}
  export METEP_NCT=1
  export METEP_NRT=3
  export METEP_NCT_BIND=Spread

  #export METEP_FORCE_NCT=1
  #export METEP_ADJ_MC=1
  #export METEP_MC_NRT=0


  #echo "MMP_NUM_THREADS      = "$METEP_NUM_THREADS
  #echo "OMP_NUM_THREADS      = "$OMP_NUM_THREADS
  #echo "MKL_NUM_THREADS      = "$MKL_NUM_THREADS
  #echo "MLAB_NUM_THREADS     = "$MLAB_NUM_THREADS
  #echo "TF_NUM_THREADS       = "$TF_NUM_THREADS
  #echo "OPENBLAS_NUM_THREADS = "$OPENBLAS_NUM_THREADS

  echo "[Metep General]"
  echo "METEP_CPU_AFFINITY       = "$METEP_CPU_AFFINITY
  echo "GOMP_CPU_AFFINITY        = "$GOMP_CPU_AFFINITY
  echo "GOMP_PROC_BIND           = "$GOMP_PROC_BIND
  echo "METEP_NUM_NODES          = "$METEP_NUM_NODES
  echo "METEP_BIND               = "$METEP_BIND

  echo ""
  echo "[Metep Gemm]"
  echo "METEP_GEMM_CPU_AFFINITY  = "$METEP_GEMM_CPU_AFFINITY
  echo "METEP_NCT_BIND           = "$METEP_NCT_BIND
  echo "METEP_NCT                = "$METEP_NCT
  echo "METEP_NRT                = "$METEP_NRT

}

set_metep_gemm_env_nc_2_close() {


  #num_threads=36

  #export METEP_NUM_THREADS=${num_threads}
  #export OMP_NUM_THREADS=${num_threads}
  #export MKL_NUM_THREADS=${num_threads}
  #export MLAB_NUM_THREADS=${num_threads}
  #export TF_NUM_THREADS=${num_threads}
  #export OPENBLAS_NUM_THREADS=${num_threads}
  #export CUDA_VISIBLE_DEVICES=-1

  cpu_affinity="0-35:2, 1-35:2"
  export METEP_CPU_AFFINITY=${cpu_affinity}
  export GOMP_CPU_AFFINITY=${cpu_affinity}
  export GOMP_PROC_BIND=CLOSE
  export METEP_NUM_NODES=2
  export METEP_BIND=Close


  export METEP_GEMM_CPU_AFFINITY=${cpu_affinity}
  export METEP_NCT=2
  export METEP_NRT=3
  export METEP_NCT_BIND=Close

  #export METEP_FORCE_NCT=1
  #export METEP_ADJ_MC=1
  #export METEP_MC_NRT=0


  #echo "METEP_NUM_THREADS      = "$METEP_NUM_THREADS
  #echo "OMP_NUM_THREADS      = "$OMP_NUM_THREADS
  #echo "MKL_NUM_THREADS      = "$MKL_NUM_THREADS
  #echo "MLAB_NUM_THREADS     = "$MLAB_NUM_THREADS
  #echo "TF_NUM_THREADS       = "$TF_NUM_THREADS
  #echo "OPENBLAS_NUM_THREADS = "$OPENBLAS_NUM_THREADS

  echo "[Metep General]"
  echo "METEP_CPU_AFFINITY       = "$METEP_CPU_AFFINITY
  echo "GOMP_CPU_AFFINITY        = "$GOMP_CPU_AFFINITY
  echo "GOMP_PROC_BIND           = "$GOMP_PROC_BIND
  echo "METEP_NUM_NODES          = "$METEP_NUM_NODES
  echo "METEP_BIND               = "$METEP_BIND

  echo ""
  echo "[Metep Gemm]"
  echo "METEP_GEMM_CPU_AFFINITY  = "$METEP_GEMM_CPU_AFFINITY
  echo "METEP_NCT_BIND           = "$METEP_NCT_BIND
  echo "METEP_NCT                = "$METEP_NCT
  echo "METEP_NRT                = "$METEP_NRT

  #echo "METEP_FORCE_NCT     = "$METEP_FORCE_NCT
  #echo "METEP_ADJ_MC        = "$METEP_ADJ_MC
  #echo "METEP_MC_NRT        = "$METEP_MC_NRT

}


set_metep_gemm_env_nc_2_spread() {


  #num_threads=36

  #export METEP_NUM_THREADS=${num_threads}
  #export OMP_NUM_THREADS=${num_threads}
  #export MKL_NUM_THREADS=${num_threads}
  #export MLAB_NUM_THREADS=${num_threads}
  #export TF_NUM_THREADS=${num_threads}
  #export OPENBLAS_NUM_THREADS=${num_threads}
  #export CUDA_VISIBLE_DEVICES=-1

  cpu_affinity="0-35"
  export METEP_CPU_AFFINITY=${cpu_affinity}
  export GOMP_CPU_AFFINITY=${cpu_affinity}
  export METEP_NUM_NODES=2
  export METEP_BIND=Spread


  export METEP_GEMM_CPU_AFFINITY=${cpu_affinity}
  export METEP_NCT=2
  export METEP_NRT=3
  export METEP_NCT_BIND=Spread

  #export METEP_FORCE_NCT=1
  #export METEP_ADJ_MC=1
  #export METEP_MC_NRT=0


  #echo "METEP_NUM_THREADS      = "$METEP_NUM_THREADS
  #echo "OMP_NUM_THREADS      = "$OMP_NUM_THREADS
  #echo "MKL_NUM_THREADS      = "$MKL_NUM_THREADS
  #echo "MLAB_NUM_THREADS     = "$MLAB_NUM_THREADS
  #echo "TF_NUM_THREADS       = "$TF_NUM_THREADS
  #echo "OPENBLAS_NUM_THREADS = "$OPENBLAS_NUM_THREADS

  echo "[Metep General]"
  echo "METEP_CPU_AFFINITY       = "$METEP_CPU_AFFINITY
  echo "GOMP_CPU_AFFINITY        = "$GOMP_CPU_AFFINITY
  echo "GOMP_PROC_BIND           = "$GOMP_PROC_BIND
  echo "METEP_NUM_NODES          = "$METEP_NUM_NODES
  echo "METEP_BIND               = "$METEP_BIND

  echo ""
  echo "[Metep Gemm]"
  echo "METEP_GEMM_CPU_AFFINITY  = "$METEP_GEMM_CPU_AFFINITY
  echo "METEP_NCT_BIND           = "$METEP_NCT_BIND
  echo "METEP_NCT                = "$METEP_NCT
  echo "METEP_NRT                = "$METEP_NRT

  #echo "METEP_FORCE_NCT     = "$METEP_FORCE_NCT
  #echo "METEP_ADJ_MC        = "$METEP_ADJ_MC
  #echo "METEP_MC_NRT        = "$METEP_MC_NRT

}

set_metep_gemm_env_nc_auto() {

  cpu_affinity="0-35:2, 1-35:2"

  export METEP_CPU_AFFINITY=${cpu_affinity}
  export GOMP_CPU_AFFINITY=${cpu_affinity}
  export GOMP_PROC_BIND=CLOSE
  export METEP_NUM_NODES=2
  export METEP_BIND=Close

  gemm_cpu_affinity="0-35:2, 1-35:2"
  # gemm_cpu_affinity="0-35"

  export METEP_GEMM_CPU_AFFINITY=${gemm_cpu_affinity}
  export METEP_NCT=2
  export METEP_NRT=0
  export METEP_NCT_BIND=Close

  #echo "METEP_NUM_THREADS      = "$METEP_NUM_THREADS
  #echo "OMP_NUM_THREADS      = "$OMP_NUM_THREADS
  #echo "MKL_NUM_THREADS      = "$MKL_NUM_THREADS
  #echo "MLAB_NUM_THREADS     = "$MLAB_NUM_THREADS
  #echo "TF_NUM_THREADS       = "$TF_NUM_THREADS
  #echo "OPENBLAS_NUM_THREADS = "$OPENBLAS_NUM_THREADS

  echo "[Metep General]"
  echo "METEP_CPU_AFFINITY       = "$METEP_CPU_AFFINITY
  echo "GOMP_CPU_AFFINITY        = "$GOMP_CPU_AFFINITY
  echo "GOMP_PROC_BIND           = "$GOMP_PROC_BIND
  echo "METEP_NUM_NODES          = "$METEP_NUM_NODES
  echo "METEP_BIND               = "$METEP_BIND

  echo ""
  echo "[Metep Gemm]"
  echo "METEP_GEMM_CPU_AFFINITY  = "$METEP_GEMM_CPU_AFFINITY
  echo "METEP_NCT_BIND           = "$METEP_NCT_BIND

  echo "METEP_NCT                = "$METEP_NCT
  echo "METEP_NRT                = "$METEP_NRT

  #echo "METEP_FORCE_NCT     = "$METEP_FORCE_NCT
  #echo "METEP_ADJ_MC        = "$METEP_ADJ_MC
  #echo "METEP_MC_NRT        = "$METEP_MC_NRT

}


show_metep_gemm_env() {

#  echo "OMP_NUM_THREADS      = "$OMP_NUM_THREADS
#  echo "MKL_NUM_THREADS      = "$MKL_NUM_THREADS
#  echo "MLAB_NUM_THREADS     = "$MLAB_NUM_THREADS
#  echo "TF_NUM_THREADS       = "$TF_NUM_THREADS
#  echo "OPENBLAS_NUM_THREADS = "$OPENBLAS_NUM_THREADS

  echo "[Metep General]"
  echo "METEP_NUM_THREADS        = "$METEP_NUM_THREADS
  echo "METEP_CPU_AFFINITY       = "$METEP_CPU_AFFINITY
  echo "GOMP_CPU_AFFINITY        = "$GOMP_CPU_AFFINITY
  echo "GOMP_PROC_BIND           = "$GOMP_PROC_BIND
  echo "METEP_NUM_NODES          = "$METEP_NUM_NODES
  echo "METEP_BIND               = "$METEP_BIND

  echo ""
  echo "[Metep Gemm]"
  echo "METEP_GEMM_CPU_AFFINITY  = "$METEP_GEMM_CPU_AFFINITY
  echo "METEP_NCT_BIND           = "$METEP_NCT_BIND
  echo "METEP_NCT                = "$METEP_NCT
  echo "METEP_NRT                = "$METEP_NRT

}

set_metep_env()   { 
  set_metep_gemm_env_nc_auto 
}
set_metep_env_nc_1_close() { 
  set_metep_gemm_env_nc_1_close
}
set_metep_env_nc_1_spread() { 
  set_metep_gemm_env_nc_1_spread
}
set_metep_env_nc_2_close() { 
  set_metep_gemm_env_nc_2_close
}
set_metep_env_nc_2_spread() { 
  set_metep_gemm_env_nc_2_spread
}

show_metep_env()  { 
  show_metep_gemm_env 
}


# [2022/11/10]
set_metep_env() {

  num_threads=$1
  export METEP_NUM_THREADS=${num_threads}

  export OMP_NUM_THREADS=${num_threads}
  export MKL_NUM_THREADS=${num_threads}
  export MLAB_NUM_THREADS=${num_threads}
  export TF_NUM_THREADS=${num_threads}
  export OPENBLAS_NUM_THREADS=${num_threads}

  cpu_affinity="0-35:2, 1-35:2"

  export METEP_CPU_AFFINITY=${cpu_affinity}
  export GOMP_CPU_AFFINITY=${cpu_affinity}

  export METEP_NUM_NODES=2
  export METEP_BIND=Close

  export METEP_NCT=2
  export METEP_NRT=0
  export METEP_NCT_BIND=Close

  #export METEP_FORCE_NCT=1
  #export METEP_ADJ_MC=1
  #export METEP_MC_NRT=0

  show_metep_env


}

set_metep_env_nc_2_close() {

  num_threads=$1
  export METEP_NUM_THREADS=${num_threads}

  export OMP_NUM_THREADS=${num_threads}
  export MKL_NUM_THREADS=${num_threads}
  export MLAB_NUM_THREADS=${num_threads}
  export TF_NUM_THREADS=${num_threads}
  export OPENBLAS_NUM_THREADS=${num_threads}

  cpu_affinity="0-35:2, 1-35:2"

  export METEP_CPU_AFFINITY=${cpu_affinity}
  export GOMP_CPU_AFFINITY=${cpu_affinity}

  export METEP_NUM_NODES=2
  export METEP_BIND=Close

  export METEP_NCT=2
  export METEP_NRT=0
  export METEP_NCT_BIND=Close

  #export METEP_FORCE_NCT=1
  #export METEP_ADJ_MC=1
  #export METEP_MC_NRT=0

  show_metep_env

}

set_metep_env_nc_2_spread() {

  num_threads=$1
  export METEP_NUM_THREADS=${num_threads}

  export OMP_NUM_THREADS=${num_threads}
  export MKL_NUM_THREADS=${num_threads}
  export MLAB_NUM_THREADS=${num_threads}
  export TF_NUM_THREADS=${num_threads}
  export OPENBLAS_NUM_THREADS=${num_threads}

  cpu_affinity="0-35"

  export METEP_CPU_AFFINITY=${cpu_affinity}
  export GOMP_CPU_AFFINITY=${cpu_affinity}

  export METEP_NUM_NODES=2
  export METEP_BIND=Spread

  export METEP_NCT=2
  export METEP_NRT=0
  export METEP_NCT_BIND=Spread

  #export METEP_FORCE_NCT=1
  #export METEP_ADJ_MC=1
  #export METEP_MC_NRT=0

  show_metep_env


}


# [2023/02/24]

show_metep_env_ex() {

  echo "[Metep Ex]"
  echo "METEP_NUM_THREADS_EX     = "$METEP_NUM_THREADS_EX
  echo "METEP_CPU_AFFINITY_EX    = "$METEP_CPU_AFFINITY_EX
  echo "METEP_NUM_NODES_EX       = "$METEP_NUM_NODES_EX
  echo "METEP_BIND_EX            = "$METEP_BIND_EX
}

set_metep_detect_env() {

  num_threads=4

  export METEP_NUM_THREADS=${num_threads}
  export OMP_NUM_THREADS=${num_threads}
  export MKL_NUM_THREADS=${num_threads}
  export MLAB_NUM_THREADS=${num_threads}
  export TF_NUM_THREADS=${num_threads}
  export OPENBLAS_NUM_THREADS=${num_threads}

  if  [[ ${num_threads} -eq 1 ]]
  then
    cpu_affinity="0"
  else
#    cpu_affinity="0-$((num_threads-1)):2 1-$((num_threads-1)):2"
    cpu_affinity="3-6"
  fi

  export GOMP_CPU_AFFINITY=${cpu_affinity}
  export GOMP_PROC_BIND=CLOSE


  export METEP_CPU_AFFINITY=${cpu_affinity}
  export METEP_GEMM_CPU_AFFINITY=${cpu_affinity}

  export METEP_NCT=2
  export METEP_NRT=0
  export METEP_NCT_BIND=Close

  export METEP_NUM_NODES=2
  export METEP_BIND=Close

  export METEP_NUM_THREADS_EX=2
  # export METEP_CPU_AFFINITY_EX="$((num_threads)) $((num_threads+1))" 
  export METEP_CPU_AFFINITY_EX="7 1"

  # if  [[ ${num_threads} -eq 1 ]]
  # then
    # export METEP_CPU_AFFINITY_EX="2, 4"
  # else
    # export METEP_CPU_AFFINITY_EX="$((num_threads)) $((num_threads+1))" 
  # fi

  export METEP_NUM_NODES_EX=2
  export METEP_BIND_EX=Close

  echo ""
  show_metep_env
  echo ""
  show_metep_env_ex
}

set_metep_detect_env_serial() {

  num_threads=$1

  export METEP_NUM_THREADS=${num_threads}
  export OMP_NUM_THREADS=${num_threads}
  export MKL_NUM_THREADS=${num_threads}
  export MLAB_NUM_THREADS=${num_threads}
  export TF_NUM_THREADS=${num_threads}
  export OPENBLAS_NUM_THREADS=${num_threads}

  if  [[ ${num_threads} -eq 1 ]]
  then
    cpu_affinity="0"
  else
    cpu_affinity="0-$((num_threads-1)):2 1-$((num_threads-1)):2"
  fi

  export GOMP_CPU_AFFINITY=${cpu_affinity}
  export GOMP_PROC_BIND=CLOSE

  #export METEP_CPU_AFFINITY="0-31:2 1-31:2"
  #export METEP_CPU_AFFINITY_EX="32-35:2 33-35:2"

  export METEP_CPU_AFFINITY=${cpu_affinity}

  export METEP_GEMM_CPU_AFFINITY=${cpu_affinity}

  export METEP_NUM_NODES=2
  export METEP_BIND=Close

  unset METEP_NUM_THREADS_EX
  unset METEP_CPU_AFFINITY_EX
  unset METEP_NUM_NODES_EX
  unset METEP_BIND_EX

  export METEP_NCT=2
  export METEP_NRT=0
  export METEP_NCT_BIND=Close

  echo ""
  show_metep_env
  echo ""
  show_metep_env_ex
}

set_metep_detect_env_ex() {

  num_threads=$1

  export METEP_NUM_THREADS_EX=${num_threads}
  cpu_affinity="$((36-num_threads))-35:2 $((36-num_threads+1))-35:2"
  export METEP_CPU_AFFINITY_EX=${cpu_affinity}
  export METEP_BIND_EX=Close

  show_metep_env
  echo ""
  show_metep_env_ex
}

unset_metep_detect_env() {

  unset METEP_NUM_THREADS

  unset OMP_NUM_THREADS
  unset MKL_NUM_THREADS
  unset MLAB_NUM_THREADS
  unset TF_NUM_THREADS
  unset OPENBLAS_NUM_THREADS

  unset GOMP_CPU_AFFINITY
  unset GOMP_PROC_BIND

  unset METEP_CPU_AFFINITY
  unset METEP_GEMM_CPU_AFFINITY

  unset METEP_NUM_NODES
  unset METEP_BIND

  unset METEP_NCT
  unset METEP_NRT
  unset METEP_NCT_BIND

  unset METEP_NUM_THREADS_EX
  unset METEP_CPU_AFFINITY_EX
  unset METEP_NUM_NODES_EX
  unset METEP_BIND_EX

  echo ""
  show_metep_env
  echo ""
  show_metep_env_ex

}

unset_metep_detect_env_ex() {

  unset METEP_NUM_THREADS_EX
  unset METEP_CPU_AFFINITY_EX
  unset METEP_NUM_NODES_EX
  unset METEP_BIND_EX

  echo ""
  show_metep_env
  echo ""
  show_metep_env_ex
}



